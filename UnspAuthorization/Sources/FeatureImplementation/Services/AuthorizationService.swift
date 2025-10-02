//
//  AuthorizationService.swift
//  UnspAuthoriztion
//
//  Created by Malik Timurkaev on 26.09.2025.
//

import Foundation

// MARK: - Service API
protocol AuthorizationServiceProtocol {
    func fetchToken(with code: String) async  throws -> AuthResponseDTO
}

final class AuthorizationService: AuthorizationServiceProtocol {
    
    /// ⚠️ В реальном приложении здесь должен быть клиент бэкенда,
    /// который держит client_secret и делает обмен code→token на сервере.
    /// Сейчас используем имитацию только для локального прототипирования.
    private let myBackendImitation = BackendImitatingService()
    
#warning("Make retry functionality based on 'response.statusCode' (e.g., 500/502/503 with backoff)")
    func fetchToken(with code: String) async throws(AuthError) -> AuthResponseDTO {
        
        do {
            let (data, response) = try await myBackendImitation.fetchToken(with: code)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AuthError.transport(underlying: URLError(.badServerResponse))
            }
            guard (200..<300).contains(httpResponse.statusCode) else {
                throw AuthError.httpStatus(httpResponse.statusCode, data)
            }
            
            do {
                return try JSONDecoder().decode(AuthResponseDTO.self, from: data)
            } catch {
                throw AuthError.decodingFailed(underlying: error)
            }
        } catch let error as URLError {
            throw .transport(underlying: error)
        } catch {
            throw .transport(underlying: error)
        }
    }
}
