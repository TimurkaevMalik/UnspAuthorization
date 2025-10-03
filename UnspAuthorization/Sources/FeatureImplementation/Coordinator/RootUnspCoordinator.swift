//
//  RootUnspCoordinator.swift
//  UnspAuthorization
//
//  Created by Malik Timurkaev on 01.10.2025.
//

import UIKit

@MainActor
protocol UnspCoordinatorProtocol {
    func start()
}

final class RootUnspCoordinator: UnspCoordinatorProtocol {
    
    private let navigation: UINavigationController
    private let keychainStorageFactory = KeychainStorageFactory()
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    func start() {
        showAuthEntryScreen()
    }
}

private extension RootUnspCoordinator {
    func showAuthEntryScreen() {
        let controller = AuthEntryViewController(output: self)
        navigation.pushViewController(controller, animated: true)
    }
    
    func showAuthorizationScreen() {
        let authorizationService = AuthorizationService()
        let tokenRepository = TokenRepository(
            authorizationService: authorizationService,
            tokenStorageFactory: keychainStorageFactory
        )
        let viewModel = AuthorizationViewModel(
            authConfig: .defaultConfig,
            tokenRepository: tokenRepository
        )
        
        let controller = AuthorizationViewController(
            viewModel: viewModel,
            output: self
        )
        navigation.present(controller, animated: true)
    }
}

extension RootUnspCoordinator: AuthEntryViewControllerOutput {
    func authEntryDidRequestStartAuth() {
        showAuthorizationScreen()
    }
}

extension RootUnspCoordinator: AuthorizationViewControllerOutput {
    func didAuthorize() {
        navigation.dismiss(animated: true)
        
        ///send flow completion
    }
}
