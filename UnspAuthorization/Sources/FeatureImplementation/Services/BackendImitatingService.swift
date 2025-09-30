//
//  BackendImitatingService.swift
//  UnspAuthoriztion
//
//  Created by Malik Timurkaev on 27.09.2025.
//

import Foundation

// MARK: - Backend imitation (for LOCAL prototyping only)

/// ВНИМАНИЕ: этот сервис имитирует бэкенд, чтобы быстро прогнать флоу локально.
/// Мы осознанно вставляем `client_secret` на клиенте — это НЕБЕЗОПАСНО и недопустимо в проде.
/// В проде нужен реальный сервер для безопасного хранения `client_secret`.
///
/// Зачем сервис нужен:
/// 1) Быстро проверить UI/флоу без развёртывания реального сервера.
/// 2) Прототипировать URL-сборку/декодинг отклика.
///
/// Почему так нельзя в бою:
/// • `client_secret` легко извлекается из IPA/памяти — его украдут и злоупотребят приложением.
/// • Unsplash ожидает, что обмен code→token делает доверенная сторона (сервер), а не iOS-клиент.

final class BackendImitatingService {
    private let accessKey = "Ix8DGsN3icXmar5IMI1Hwy0G2L8MotFf93HczcjVPOk"
    private let secretKey = "gES-oqwCmHGffOoObk03kstACihBSBn9jKpo77N7wTg"
    
    func fetchToken(using code: String) async throws(AuthError) -> (Data, URLResponse) {
        guard let request = makeURL(with: code) else { throw .invalidURL }
        
        do {
            return try await URLSession.shared.data(for: request)
        } catch {
            throw .transport(underlying: error)
        }
    }
    
    func makeURL(with codeValue: String) -> URLRequest? {
        
        let clientId = "client_id"
        let clientSecret = "client_secret"
        let redirectURI = QueryItemNames.redirectURI.rawValue
        let grantType = QueryItemNames.grantType.rawValue
        let codeName = QueryItemNames.code.rawValue
        
        let builder = URLBuilder()
            .scheme(Scheme.https.rawValue)
            .host(Host.unsplash.rawValue)
            .path(Path.build([.oauth, .token]))
            .queryItem(name: clientId, value: accessKey)
            .queryItem(name: clientSecret, value: secretKey)
            .queryItem(name: redirectURI, value: "urn:ietf:wg:oauth:2.0:oob")
            .queryItem(name: grantType, value: "authorization_code")
            .queryItem(name: codeName, value: codeValue)
        
        guard let url = builder.build() else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        return request
    }
}
