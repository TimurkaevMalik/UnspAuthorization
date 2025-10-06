//
//  StorageKeys.swift
//  UnspAuthorization
//
//  Created by Malik Timurkaev on 03.10.2025.
//

import Foundation

enum StorageKeys: String {
    case accessToken = "auth.access"
    case refreshToken = "auth.refresh"
    case currentUserID = "currentUserID"
    case accessTokenCreatedAt = "refreshTokenCreatedAt"
    case refreshTokenCreatedAt = "accessTokenCreatedAt"
}
