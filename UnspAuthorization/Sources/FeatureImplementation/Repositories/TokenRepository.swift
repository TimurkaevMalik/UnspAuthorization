//
//  TokenRepository.swift
//  UnspAuthoriztion
//
//  Created by Malik Timurkaev on 27.09.2025.
//

import Foundation
import LoggingKit
import KeychainStorageKit

protocol TokenRepositoryProtocol {
    func fetchToken(with code: String) async throws -> Token
    func currentToken(forKey key: StorageKeys) throws -> Token?
    func clearAccessToken() throws
    func clearRefreshToken() throws
}

final class TokenRepository: TokenRepositoryProtocol {
    
    private let logger: LoggerProtocol?
    private let authorizationService: AuthorizationServiceProtocol
    private let tokenStorageFactory: KeychainStorageFactoryProtocol
    private let preferences: PreferencesProtocol
    
    private var tokenStorage: KeychainStorageProtocol?
    
    init(
        authorizationService: AuthorizationServiceProtocol,
        tokenStorageFactory: KeychainStorageFactoryProtocol,
        preferences: PreferencesProtocol = UserDefaults.standard,
        logger: LoggerProtocol? = nil
    ) {
        self.logger = logger
        self.authorizationService = authorizationService
        self.preferences = preferences
        self.tokenStorageFactory = tokenStorageFactory
    }
    
    func fetchToken(with code: String) async throws -> Token {
        let responseDTO = try await authorizationService.fetchToken(with: code)
        let accessToken = Token(asAccessToken: responseDTO)
        let refreshToken = Token(asRefreshToken: responseDTO)
        
        try validate(accessToken)
        try validate(refreshToken)
        
        if tokenStorage == nil {
            tokenStorage = tokenStorageFactory.make(with: responseDTO.userID)
        }
        
        try store(token: accessToken, forKey: StorageKeys.accessToken)
        try store(token: refreshToken, forKey: StorageKeys.refreshToken)
        
        storePreferences(
            data: responseDTO.userID,
            forKey: StorageKeys.currentUserID
        )
        storePreferences(
            data: accessToken.createdAt,
            forKey: StorageKeys.accessTokenCreatedAt
        )
        storePreferences(
            data: refreshToken.createdAt,
            forKey: StorageKeys.refreshTokenCreatedAt
        )
        
        return accessToken
    }
    
    func currentToken(forKey key: StorageKeys) throws -> Token? {
        guard let tokenStorage else { throw RepoError.storageNotConfigured }
        return try tokenStorage.loadValue(forKey: key.rawValue)
    }
    
    func clearAccessToken() throws {
        guard let tokenStorage else { throw RepoError.storageNotConfigured }
        try tokenStorage.removeObject(forKey: StorageKeys.accessToken.rawValue)
        preferences.removeObject(forKey: StorageKeys.accessTokenCreatedAt.rawValue)
    }
    
    func clearRefreshToken() throws {
        guard let tokenStorage else { throw RepoError.storageNotConfigured }
        try tokenStorage.removeObject(forKey: StorageKeys.refreshToken.rawValue)
        preferences.removeObject(forKey: StorageKeys.refreshTokenCreatedAt.rawValue)
    }
}

private extension TokenRepository {
    func store(token: Token, forKey key: StorageKeys) throws {
        try tokenStorage?.set(token, forKey: key.rawValue)
    }
    
    func storePreferences(data: Any, forKey key: StorageKeys) {
        preferences.set(data, forKey: key.rawValue)
    }
    
    func validate(_ token: Token) throws(RepoError) {
        if token.type == .unknown {
            logger?.notice("Unknown token type")
        }
        
        if token.token.isEmpty {
            logger?.notice("Empty token")
            throw .emptyToken
        }
    }
}

extension TokenRepository {
    enum RepoError: Error {
        case emptyToken
        case storageNotConfigured
    }
}
