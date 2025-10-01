//
//  AuthorizationViewController.swift
//  FeatureTemplate
//
//  Created by Malik Timurkaev on 26.09.2025.
//


import UIKit
import FontsKit

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


final class AuthorizationView: UIView {
    
    private lazy var titleLabel = {
        let uiView = UILabel()
        uiView.textAlignment = .center
        uiView.textColor = Palette.uiColor(.blackPrimary)
        uiView.font = FontSystem.Title.xl
        uiView.text = "Unsplash"
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AuthorizationView {
    func setupUI() {
        backgroundColor = Palette.uiColor(.whitePrimary)
        
        addSubview(titleLabel)
        
        let horizontalOffset = Insets.Title.Horizontal.xxl
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalOffset),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalOffset)
        ])
    }
}
