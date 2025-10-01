//
//  AuthorizationView.swift
//  UnspAuthorization
//
//  Created by Malik Timurkaev on 01.10.2025.
//

import UIKit
import FontsKit
import SnapKit

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
        let horizontalInset = Insets.Title.Horizontal.xxl
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(horizontalInset)
        }
    }
}
