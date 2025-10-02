//
//  AuthResponseDTO.swift
//  UnspAuthoriztion
//
//  Created by Malik Timurkaev on 26.09.2025.
//

import Foundation

// MARK: - Domain
struct Token: Codable {
    let token: String
    let type: TokenType
    let createdAt: Date
    
    enum TokenType: String, Codable {
        case bearer = "Bearer"
        case refresh = "Refresh"
        case unknown = "unknown"
    }
}

extension Token {
    init(asAccessToken dto: AuthResponseDTO) {
        token = dto.accessToken
        type = TokenType(rawValue: dto.type) ?? .unknown
        createdAt = Date(timeIntervalSince1970: TimeInterval(dto.createdAt))
    }
    
    init(asRefreshToken dto: AuthResponseDTO) {
        token = dto.refreshToken
        type = .refresh
        createdAt = Date(timeIntervalSince1970: TimeInterval(dto.createdAt))
    }
}
