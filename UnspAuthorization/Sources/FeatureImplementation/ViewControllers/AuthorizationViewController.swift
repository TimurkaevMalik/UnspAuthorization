//
//  AuthorizationViewController.swift
//  FeatureTemplate
//
//  Created by Malik Timurkaev on 26.09.2025.
//


import UIKit

final class AuthorizationViewController: UIViewController {
    
    private lazy var rootView: AuthorizationView = {
        let uiView = AuthorizationView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
}
