//
//  AuthorizationViewModelProtocol.swift
//  UnspAuthorization
//
//  Created by Malik Timurkaev on 01.10.2025.
//

import Foundation

protocol AuthorizationViewModelProtocol {
    var authorizationUrlRequest: URLRequest? { get }
    func fetchToken(with code: String)
}

final class AuthorizationViewModel: AuthorizationViewModelProtocol {
    
    
    private let authConfig: AuthenticationConfig
    private let tokenRepository: TokenRepositoryProtocol
    
    lazy var authorizationUrlRequest: URLRequest?  = {
        return buildURLRequest()
    }()
    
    init(
        authConfig: AuthenticationConfig,
        tokenRepository: TokenRepositoryProtocol
    ) {
        self.authConfig = authConfig
        self.tokenRepository = tokenRepository
    }
    
    func fetchToken(with code: String) {
        Task {
            try await tokenRepository.fetchToken(with: code)
        }
    }
}

private extension AuthorizationViewModel {
    func buildURLRequest() -> URLRequest? {
        let clientIDName = QueryItemNames.clientID.rawValue
        let redirectURIName = QueryItemNames.redirectURI.rawValue
        let scopeName = QueryItemNames.scope.rawValue
        let responseTypeName = QueryItemNames.responseType.rawValue
        
        let url = URLBuilder()
            .scheme(authConfig.authURL.scheme.rawValue)
            .host(authConfig.authURL.host.rawValue)
            .path(authConfig.configurePath())
            .queryItem(name: clientIDName, value: authConfig.clientId)
            .queryItem(name: redirectURIName, value: authConfig.redirectURI)
            .queryItem(name: scopeName, value: authConfig.configureScope())
            .queryItem(name: responseTypeName, value: authConfig.responseType)
            .build()
        
        guard let url else { return nil }
        return URLRequest(url: url)
    }
}
