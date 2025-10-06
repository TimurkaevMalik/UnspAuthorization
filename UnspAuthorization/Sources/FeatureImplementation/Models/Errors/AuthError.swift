//
//  AuthError.swift
//  UnspAuthoriztion
//
//  Created by Malik Timurkaev on 27.09.2025.
//

import Foundation

enum AuthError: Error, Sendable {
    case invalidURL
    case httpStatus(Int, Data?)
    case decodingFailed(underlying: Error)
    /// Сетевая ошибка уровня URLSession.
    case transport(underlying: Error)
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL for token request."
        case .httpStatus(let code, _):
            return "HTTP error \(code) while fetching token."
        case .decodingFailed(let e):
            return "Failed to decode token response: \(e.localizedDescription)"
        case .transport(let e):
            return "Network error: \(e.localizedDescription)"
        }
    }
}
