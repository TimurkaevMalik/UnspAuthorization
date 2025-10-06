//
//  NetworkKitPath+ext.swift
//  UnspAuthorization
//
//  Created by Malik Timurkaev on 06.10.2025.
//

import NetworkKit

extension Path {
    static let oauth    : Path = .segment("oauth")
    static let token    : Path = .segment("token")
    static let authorize: Path = .segment("authorize")
}
