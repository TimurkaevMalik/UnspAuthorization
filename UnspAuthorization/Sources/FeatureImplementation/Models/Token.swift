//
//  TokenDTO.swift
//  UnspAuthoriztion
//
//  Created by Malik Timurkaev on 26.09.2025.
//

import Foundation

// MARK: - DTO
struct TokenDTO: Decodable {
    let token: String
    let type: String
    let createdAt: Int
    
    private enum CodingKeys: String, CodingKey {
            case token = "access_token"
            case type = "token_type"
            case createdAt = "created_at"
    }
}

// MARK: - Domain
struct Token: Codable {
    let token: String
    let type: TokenType
    let createdAt: Date
    
    enum TokenType: String, Codable {
        case bearer = "Bearer"
        case unknown = "unknown"
    }
}

extension Token {
    init(dto: TokenDTO) {
        token = dto.token
        type = TokenType(rawValue: dto.type) ?? .unknown
        createdAt = Date(timeIntervalSince1970: TimeInterval(dto.createdAt))
    }
}
