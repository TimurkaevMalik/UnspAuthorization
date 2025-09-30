//
//  TokenRepository.swift
//  UnspAuthoriztion
//
//  Created by Malik Timurkaev on 27.09.2025.
//

import Foundation

protocol TokenRepositoryProtocol {
    func fetchToken(using code: String) async throws
    func currentToken() -> Token?
    func clearToken() throws
}

protocol TokenStorageProtocol {
    func save(_ token: Token) throws
    func load() -> Token
    func clear() throws
}

final class TokenRepository: TokenRepositoryProtocol {
    
    let logger: MultiplexLogger
    let authorizationService: AuthorizationServiceProtocol
    let tokenStorage: TokenStorageProtocol
    
    init(
        authorizationService: AuthorizationServiceProtocol,
        tokenStorage: TokenStorageProtocol,
        logers: [LoggerSink]
    ) {
        self.authorizationService = authorizationService
        self.tokenStorage = tokenStorage
        self.logger = MultiplexLogger(loggers: logers)
    }
    
    func fetchToken(using code: String) async throws {
        let tokenDTO = try await authorizationService.fetchToken(using: code)
        let token = Token(dto: tokenDTO)
    }
    
    func currentToken() -> Token? {
        tokenStorage.load()
    }
    
    func clearToken() throws {
        try tokenStorage.clear()
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
            logger.notice("Empty token")
            throw .emptyToken
        }
        guard token.type != .unknown else {
            logger.notice("Unknown token type")
            return
        }
    }
}
