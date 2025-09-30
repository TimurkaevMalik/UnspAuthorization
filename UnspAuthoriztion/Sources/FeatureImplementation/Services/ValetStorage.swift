//
//  RepoError.swift
//  UnspAuthoriztion
//
//  Created by Malik Timurkaev on 30.09.2025.
//

import Foundation
import Valet

protocol KeychainStorageProtocol {
    typealias CustomError = KeychainServiceError
    func set<T: Encodable>(_ value: T, forKey key: String) throws(CustomError)
    func loadValue<T: Decodable>(forKey key: String) throws(CustomError) -> T?
    func removeObject(forKey key: String) throws(CustomError)
    func removeAll() throws(CustomError)
}

final class ValetStorage: KeychainStorageProtocol {
    
    private let logger: LoggerProtocol?
    private let valet: Valet
    
    init(
        id: Identifier,
         accessibility: KeychainAccessibility,
         logers: [LoggerSink]
    ) {
        logger = logers.isEmpty ? nil : MultiplexLogger(loggers: logers)
        self.valet = Valet.valet(with: id, accessibility: accessibility.valetValue)
    }
    
    func set<T: Encodable>(_ value: T, forKey key: String) throws(CustomError) {
        do {
            let data = try JSONEncoder().encode(value)
            try valet.setObject(data, forKey: key)
        } catch {
            if let mappedError = map(error: error) {
                throw mappedError
            }
        }
    }
    
    func loadValue<T: Decodable>(forKey key: String) throws(CustomError) -> T? {
        
        do {
            let data = try valet.object(forKey: key)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            if let mappedError = map(error: error) {
                throw mappedError
            } else {
                return nil
            }
        }
    }
        
    func removeObject(forKey key: String) throws(CustomError) {
        do {
            try valet.removeObject(forKey: key)
        } catch {
            if let mappedError = map(error: error) {
                throw mappedError
            }
        }
    }
    
    func removeAll() throws(CustomError) {
        do {
            try valet.removeAllObjects()
        } catch {
            if let mappedError = map(error: error) {
                throw mappedError
            }
        }
    }
    
    private func map(error: Error) -> CustomError? {
        if let error = error as? KeychainError {
            
            switch error {
                
            case .itemNotFound, .emptyValue:
                return nil
                
            case .emptyKey:
                logger?.error("Keychain: empty key. Programmer error: \(error)")
                return .underlying(error)
    
            // Нет прав/доступа к связке (entitlements/iCloud/off) → фатально
            case .couldNotAccessKeychain, .missingEntitlement, .userCancelled:
                    return .underlying(error)
                    
            }
        } else {
            return .underlying(error)
        }
    }
}

enum KeychainAccessibility {
    case whenUnlockedThisDeviceOnly
}

/// Маппинг нашего уровня доступности на Valet/Keychain.
fileprivate extension KeychainAccessibility {
    var valetValue: Accessibility {
        switch self {
        case .whenUnlockedThisDeviceOnly:
                .whenUnlockedThisDeviceOnly
        }
    }
}


enum KeychainServiceError: Error {
    case notFound
    case encodingFailed(Error)
    case decodingFailed(Error)
    case underlying(Error)
}
