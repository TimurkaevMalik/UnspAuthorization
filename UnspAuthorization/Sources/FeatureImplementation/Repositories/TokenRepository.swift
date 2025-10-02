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
    func currentToken() throws -> Token?
    func clearToken() throws
}

final class TokenRepository: TokenRepositoryProtocol {
    
    private let logger: LoggerProtocol?
    private let authorizationService: AuthorizationServiceProtocol
    private let tokenStorageFactory: KeychainStorageFactoryProtocol
    
    private var tokenStorage: KeychainStorageProtocol?
    
    init(
        authorizationService: AuthorizationServiceProtocol,
        tokenStorageFactory: KeychainStorageFactoryProtocol,
        logger: LoggerProtocol? = nil
    ) {
        self.logger = logger
        self.authorizationService = authorizationService
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
        
        try store(token: accessToken, forKey: "SOMEKEY")
        try store(token: refreshToken, forKey: "SOMEKEY")
        return accessToken
    }
    
    func currentToken() throws -> Token? {
        try tokenStorage?.loadValue(forKey: "SOMEKEY")
    }
    
    func clearToken() throws {
        try tokenStorage?.removeObject(forKey: "SOMEKEY")
    }
}

private extension TokenRepository {
    func store(token: Token, forKey key: String) throws {
        try tokenStorage?.set(token, forKey: key)
    }

    func validate(_ token: Token) throws(RepoError) {
        guard !token.token.isEmpty else {
            logger?.notice("Empty token")
            throw .emptyToken
        }
        guard token.type != .unknown else {
            logger?.notice("Unknown token type")
            return
        }
    }
}

extension TokenRepository {
    enum RepoError: Error {
        case emptyToken
    }
}
