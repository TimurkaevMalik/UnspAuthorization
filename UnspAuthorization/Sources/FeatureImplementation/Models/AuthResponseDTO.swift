//
//  AuthResponseDTO.swift
//  UnspAuthorization
//
//  Created by Malik Timurkaev on 03.10.2025.
//

import Foundation

// MARK: - DTO
struct AuthResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let type: String
    let userID: String
    let createdAt: Int
    
    private enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case refreshToken = "refresh_token"
            case type = "token_type"
            case userID = "user_id"
            case createdAt = "created_at"
    }
}
