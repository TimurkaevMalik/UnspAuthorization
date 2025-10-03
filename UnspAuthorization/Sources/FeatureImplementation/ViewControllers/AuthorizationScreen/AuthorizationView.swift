//
//  AuthorizationView.swift
//  UnspAuthorization
//
//  Created by Malik Timurkaev on 01.10.2025.
//

import Foundation
import SnapKit
import WebKit

@MainActor
protocol AuthorizationViewOutput: AnyObject {
    func didReceiveAuthorizationCode(_ code: String)
    func didFailAuthorization(with error: AuthError)
}

final class AuthorizationView: UIView {
    
    private weak var output: AuthorizationViewOutput?
    
    private lazy var webView = {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .nonPersistent()
        let uiView = WKWebView(frame: .zero, configuration: config)
        
        uiView.navigationDelegate = self
        uiView.translatesAutoresizingMaskIntoConstraints = false
        
        return uiView
    }()
    
    init(output: AuthorizationViewOutput?) {
        self.output = output
        super.init(frame: .zero)
        backgroundColor = Palette.uiColor(.whitePrimary)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadWebPage(with urlRequest: URLRequest) {
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
        
        if let url = navigationAction.request.url,
           let code = code(from: url) {
            
            webView.stopLoading()
            output?.didReceiveAuthorizationCode(code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

private extension AuthorizationView {
    func code(from url: URL) -> String? {
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let code = components.queryItems?.first(where: { $0.name == "code" })?.value {
            
            return code
        }
        
        return nil
    }
}
