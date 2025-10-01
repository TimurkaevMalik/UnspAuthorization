//
//  AuthorizationView.swift
//  UnspAuthorization
//
//  Created by Malik Timurkaev on 01.10.2025.
//

import Foundation
import SnapKit
import WebKit

final class AuthorizationView: UIView {
    
    private lazy var webView = {
        let uiView = WKWebView()
        uiView.navigationDelegate = self
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    let urlRequest: URLRequest
    
    init(request: URLRequest) {
        urlRequest = request
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadAuthorizationPage() {
        webView.load(urlRequest)
    }
    
    func setupUI() {
        addSubview(webView)
        webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension AuthorizationView: WKNavigationDelegate {
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping @MainActor (WKNavigationActionPolicy
        ) -> Void) {
        
        if let url = navigationAction.request.url {
            if url.absoluteString.hasPrefix(AuthConstants.redirectURI) {
                handleRedirect(url: url)
                decisionHandler(.cancel)
                return
            }
        }
        
        decisionHandler(.allow)
    }
}

private extension AuthorizationView {
    func handleRedirect(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let code = components.queryItems?.first(where: { $0.name == "code" })?.value
        else {
            return
        }
        
        webView.stopLoading()
    }
}
