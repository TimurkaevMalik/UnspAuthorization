//
//  AuthConfiguration.swift
//  UnspAuthoriztion
//
//  Created by Malik Timurkaev on 26.09.2025.
//

import Foundation
import NetworkKit

struct AuthenticationConfig {
    let clientId: String
    let redirectURI: String
    let responseType: String
    let authURL: (scheme: Scheme, host: Host, path: [Path])
    let scope: [AccessScope]
    
    init(
        clientId: String,
        redirectURI: String,
        responseType: String = "code",
        authURL: (scheme: Scheme, host: Host, path: [Path]),
        scope: [AccessScope]
    ) {
        self.clientId = clientId
        self.redirectURI = redirectURI
        self.responseType = responseType
        self.authURL = authURL
        self.scope = scope
    }
    
    func configureScope() -> String {
        scope.map({ $0.rawValue }).joined(separator: "+")
    }
    
    func configurePath() -> String {
        Path.build(authURL.path)
    }
}

extension AuthenticationConfig {
    static var defaultConfig: AuthenticationConfig {
        AuthenticationConfig(
            clientId: AuthConstants.clientID,
            redirectURI: AuthConstants.redirectURI,
            authURL: (
                scheme: .https,
                host: .unsplash,
                path: [.oauth, .authorize]
            ),
            scope: [.public, .readUser, .writeLikes]
        )
    }
}
