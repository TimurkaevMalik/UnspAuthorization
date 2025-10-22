//
//  RootUnspAuthCoordinator.swift
//  UnspAuthorization
//
//  Created by Malik Timurkaev on 01.10.2025.
//

import UIKit
import CoreKit
import KeychainStorageKit
import HelpersSharedUnsp

@MainActor
public final class RootUnspAuthCoordinator: Coordinator {
    public weak var finishDelegate: CoordinatorFinishDelegate?
    
    private let navigation: UINavigationController
    private let keychainStorageFactory = KeychainStorageFactory()
    
    public init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    public func start() {
        if isUserAuthorized() {
            finish()
        } else {
            showAuthEntryScreen()
        }
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

private extension RootUnspAuthCoordinator {
    func isUserAuthorized() -> Bool {
        if let keychain =  KeychainStorageFactory().makeIfUserExists(from: UserDefaults.standard),
           let token = try? keychain.string(forKey: StorageKeys.accessToken.rawValue),
           !token.isEmpty {
            
            return true
        }
        
        return false
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
