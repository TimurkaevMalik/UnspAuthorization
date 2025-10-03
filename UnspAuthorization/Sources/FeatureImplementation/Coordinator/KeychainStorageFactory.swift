//
//  KeychainStorageFactory.swift
//  UnspAuthorization
//
//  Created by Malik Timurkaev on 03.10.2025.
//

import Foundation
import LoggingKit
import KeychainStorageKit

protocol KeychainStorageFactoryProtocol {
    func make(with identifier: String) -> KeychainStorageProtocol?
}

final class KeychainStorageFactory: KeychainStorageFactoryProtocol {
    ///id нужен для изоляции данных нескольких пользователей одного приложения
    func make(with id: String) -> KeychainStorageProtocol? {
        let logger = OSLogAdapter(
            subsystem: "com.yourcompany.unspauthorization",
            category: ""
        )
        
        return ValetStorage(
            id: id,
            accessibility: .whenUnlockedThisDeviceOnly,
            logger: RootCompositeLogger(loggers: [logger])
        )
    }
}
