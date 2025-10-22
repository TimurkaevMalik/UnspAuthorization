//
//  KeychainStorageFactory.swift
//  UnspAuthorization
//
//  Created by Malik Timurkaev on 03.10.2025.
//

import Foundation
import CoreKit
import LoggingKit
import KeychainStorageKit
import HelpersSharedUnsp

protocol KeychainStorageFactoryProtocol {
    func makeForUser(with identifier: String) -> KeychainStorageProtocol?
}

final class KeychainStorageFactory: KeychainStorageFactoryProtocol {
    ///id нужен для изоляции данных нескольких пользователей одного приложения
    func makeForUser(with id: String) -> KeychainStorageProtocol? {
        
        ValetStorage(
            id: id,
            accessibility: .whenUnlockedThisDeviceOnly,
            logger: RootCompositeLogger(loggers: [makeLogger()])
        )
    }
    
    func makeIfUserExists(from preferences: PreferencesProtocol) -> KeychainStorageProtocol? {
        
        let logger = makeLogger()
        
        let userID = preferences.retrieve(
            String.self,
            forKey: StorageKeys.currentUserID.rawValue
        )
        
        guard let userID else { return nil }
        
        return ValetStorage(
            id: userID,
            accessibility: .whenUnlockedThisDeviceOnly,
            logger: RootCompositeLogger(loggers: [logger])
        )
    }
}

private extension KeychainStorageFactory {
    func makeLogger() -> LoggerSink {
        OSLogAdapter(
            subsystem: "com.yourcompany.unspauthorization",
            category: "auth_keychain"
        )
    }
}
