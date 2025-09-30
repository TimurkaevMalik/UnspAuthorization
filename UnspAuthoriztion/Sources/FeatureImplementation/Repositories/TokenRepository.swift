//
//  TokenRepository.swift
//  UnspAuthoriztion
//
//  Created by Malik Timurkaev on 27.09.2025.
//

import Foundation

protocol TokenRepositoryProtocol {
    func fetchToken(using code: String) async throws -> Token
    func currentToken() throws -> Token?
    func clearToken() throws
}

final class TokenRepository: TokenRepositoryProtocol {
    
    private let logger: LoggerProtocol?
    private let authorizationService: AuthorizationServiceProtocol
    private let tokenStorage: KeychainStorageProtocol
    
    init(
        authorizationService: AuthorizationServiceProtocol,
        tokenStorage: KeychainStorageProtocol,
        logger: LoggerProtocol? = nil
    ) {
        self.logger = logger
        self.authorizationService = authorizationService
        self.tokenStorage = tokenStorage
    }
    
    func fetchToken(using code: String) async throws -> Token {
        let tokenDTO = try await authorizationService.fetchToken(using: code)
        let token = Token(dto: tokenDTO)
        try tokenStorage.set(token, forKey: "SOMEKEY")
        return token
    }
    
    func currentToken() throws -> Token? {
        try tokenStorage.loadValue(forKey: "SOMEKEY")
    }
    
    func clearToken() throws {
        try tokenStorage.removeObject(forKey: "SOMEKEY")
    }
}

extension TokenRepository {
    enum RepoError: Error {
        case emptyToken
    }
}

private extension TokenRepository {
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
