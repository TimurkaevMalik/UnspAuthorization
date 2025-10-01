//
//  AuthorizationViewController.swift
//  UnspAuthorization
//
//  Created by Malik Timurkaev on 01.10.2025.
//

import UIKit

final class AuthorizationViewController: UIViewController {
    
    private let rootView: UIView = {
        let uiView = UIView()
        return uiView
    }()
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Palette.uiColor(.whitePrimary)
    }
}
