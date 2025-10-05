//
//  RootUnspAuthCoordinator.swift
//  UnspAuthorization
//
//  Created by Malik Timurkaev on 01.10.2025.
//

import UIKit
import CoreKit

@MainActor

final class RootUnspAuthCoordinator: Coordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    
    private let navigation: UINavigationController
    private let keychainStorageFactory = KeychainStorageFactory()
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    func start() {
        showAuthEntryScreen()
    }
}

private extension RootUnspAuthCoordinator {
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

extension RootUnspAuthCoordinator: AuthEntryViewControllerOutput {
    func authEntryDidRequestStartAuth() {
        showAuthorizationScreen()
    }
}

extension RootUnspAuthCoordinator: AuthorizationViewControllerOutput {
    func didAuthorize() {
        navigation.dismiss(animated: true)
        finishDelegate?.didFinishChild(self)
    }
}
