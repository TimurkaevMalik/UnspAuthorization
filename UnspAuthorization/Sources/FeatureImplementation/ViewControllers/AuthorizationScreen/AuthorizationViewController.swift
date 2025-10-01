//
//  AuthorizationViewController.swift
//  UnspAuthorization
//
//  Created by Malik Timurkaev on 01.10.2025.
//

import UIKit

final class AuthorizationViewController: UIViewController {
    
    private let vm: AuthorizationViewModelProtocol
    
    private lazy var rootView: AuthorizationView? = {
        if let request = vm.authorizationUrlRequest {
            let uiView = AuthorizationView(request: request)
            return uiView
        } else {
            return nil
        }
    }()
    
    init(viewModel: AuthorizationViewModelProtocol) {
        self.vm = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        if let rootView {
            view = rootView
        } else {
            super.loadView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Palette.uiColor(.whitePrimary)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rootView?.setupUI()
        rootView?.loadAuthorizationPage()
    }
}
