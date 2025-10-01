//
//  AuthorizationViewModelProtocol.swift
//  UnspAuthorization
//
//  Created by Malik Timurkaev on 01.10.2025.
//

import Foundation

protocol AuthorizationViewModelProtocol {
    var authorizationUrlRequest: URLRequest? { get }
}

final class AuthorizationViewModel: AuthorizationViewModelProtocol {
    
    private let authConfig: AuthenticationConfig
    
    lazy var authorizationUrlRequest: URLRequest?  = {
        return buildURLRequest()
    }()
    
    init(authConfig: AuthenticationConfig) {
        self.authConfig = authConfig
    }
    
    private func buildURLRequest() -> URLRequest? {
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
