//
//  AuthConfiguration.swift
//  UnspAuthoriztion
//
//  Created by Malik Timurkaev on 26.09.2025.
//


import Foundation

struct AuthConfiguration {
    let redirectURI: String
    let authURL: String
    let scope: [AccessScope]
    
    func configureScope() -> String {
        scope.map({ $0.rawValue }).joined(separator: "+")
    }
}
