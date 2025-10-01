//
//  AuthorizationView.swift
//  UnspAuthorization
//
//  Created by Malik Timurkaev on 01.10.2025.
//

import UIKit
import FontsKit
import SnapKit

@MainActor
protocol AuthEntryViewOutput: AnyObject {
    func authButtonTapped()
}

final class AuthEntryView: UIView {
        
    private weak var output: AuthEntryViewOutput?
    
    private lazy var titleLabel = {
        let uiView = UILabel()
        uiView.textAlignment = .center
        uiView.textColor = Palette.uiColor(.blackPrimary)
        uiView.font = FontSystem.Title.xl
        uiView.text = "Unsplash"
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    private lazy var authButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        
        config.title = "Авторизоваться"
        config.baseBackgroundColor = Palette.uiColor(.blackPrimary)
        config.baseForegroundColor = Palette.uiColor(.whitePrimary)
        config.cornerStyle = .small
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0)
        
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(output: AuthEntryViewOutput? = nil) {
        self.output = output
        super.init(frame: .zero)
        setupUI()
        setupButtonAction()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AuthEntryView {
    func setupUI() {
        backgroundColor = Palette.uiColor(.whitePrimary)
        addSubview(titleLabel)
        addSubview(authButton)
        
        let horizontalInset = Insets.Title.Horizontal.xxl
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(horizontalInset)
        }
        
        authButton.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview().inset(horizontalInset)
        }
    }
    
    func setupButtonAction() {
        let action = UIAction { [weak self] _ in
            self?.output?.authButtonTapped()
        }
        authButton.addAction(action, for: .touchUpInside)
    }
}
