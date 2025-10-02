//
//  RootUnspCoordinator.swift
//  UnspAuthorization
//
//  Created by Malik Timurkaev on 01.10.2025.
//

import UIKit
import KeychainStorageKit

@MainActor
protocol UnspCoordinatorProtocol {
    func start()
}

final class RootUnspCoordinator: UnspCoordinatorProtocol {
    
    private let navigation: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    func start() {
        showAuthEntryScreen()
    }
}

extension RootUnspCoordinator {
    func showAuthEntryScreen() {
        let controller = AuthEntryViewController(output: self)
        navigation.pushViewController(controller, animated: true)
    }
    
    func showAuthorizationScreen() {
        let authorizationService = AuthorizationService()
        let tokenRepository = TokenRepository(
            authorizationService: authorizationService,
            tokenStorageFactory: KeychainStorageFactory()
        )
        let viewModel = AuthorizationViewModel(
            authConfig: .defaultConfig,
            tokenRepository: tokenRepository
        )
        
        let controller = AuthorizationViewController(viewModel: viewModel)
        navigation.pushViewController(controller, animated: true)
    }
}

extension RootUnspCoordinator: AuthEntryViewControllerOutput {
    func authEntryDidRequestStartAuth() {
        showAuthorizationScreen()
    }
}

import LoggingKit

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
