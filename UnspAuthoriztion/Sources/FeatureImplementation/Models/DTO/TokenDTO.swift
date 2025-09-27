//
//  TokenDTO.swift
//  UnspAuthoriztion
//
//  Created by Malik Timurkaev on 26.09.2025.
//

import Foundation

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
