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
        let viewModel = AuthorizationViewModel(authConfig: .defaultConfig)
        let controller = AuthorizationViewController(viewModel: viewModel)
        navigation.pushViewController(controller, animated: true)
    }
}

extension RootUnspCoordinator: AuthEntryViewControllerOutput {
    func authEntryDidRequestStartAuth() {
        showAuthorizationScreen()
    }
}
