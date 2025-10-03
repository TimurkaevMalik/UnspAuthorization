//
//  AuthorizationViewController.swift
//  UnspAuthorization
//
//  Created by Malik Timurkaev on 01.10.2025.
//

import UIKit

@MainActor
protocol AuthorizationViewControllerOutput: AnyObject {
    func didAuthorize()
}

final class AuthorizationViewController: UIViewController {
    
    private let vm: AuthorizationViewModelProtocol
    private weak var output: AuthorizationViewControllerOutput?
    
    private lazy var rootView = AuthorizationView(output: self)
    
    private lazy var alertController = {
        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .alert
        )
        return alert
    }()
    
    init(
        viewModel: AuthorizationViewModelProtocol,
        output: AuthorizationViewControllerOutput? = nil
    ) {
        self.vm = viewModel
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rootView.setupUI()
        if let request = vm.authorizationUrlRequest {
            rootView.loadWebPage(with: request)
        } else {
            showAlert(message: "Failed to load web page")
        }
    }
}

extension AuthorizationViewController: AuthorizationViewOutput {
    func didReceiveAuthorizationCode(_ code: String) {
        Task {
            do {
                try await vm.fetchToken(with: code)
                
                if let token = try vm.currentToken(forKey: .accessToken) {
                    print(token)
                    output?.didAuthorize()
                }
            } catch {
                showAlert(message: "Failed to authorize")
            }
        }
    }
    
    func didFailAuthorization(with error: AuthError) {
        showAlert(message: "Failed to authorize")
    }
}

private extension AuthorizationViewController {
    private func showAlert(message: String) {
        alertController.message = message
        alertController.title = "Error"
        
        let action = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}
