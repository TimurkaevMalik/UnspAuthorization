//
//  AuthorizationView.swift
//  UnspAuthorization
//
//  Created by Malik Timurkaev on 01.10.2025.
//

import Foundation
import SnapKit
import WebKit

enum AuthenticationError: Error {
    case missingCode
}

@MainActor
protocol AuthorizationViewOutput: AnyObject {
    func didReceiveAuthorizationCode(_ code: String)
    func didFailAuthorization(with error: AuthenticationError)
}

final class AuthorizationView: UIView {
    
    private weak var output: AuthorizationViewOutput?
    
    private lazy var webView = {
        let uiView = WKWebView()
        uiView.navigationDelegate = self
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    let urlRequest: URLRequest
    
    init(request: URLRequest, output: AuthorizationViewOutput?) {
        urlRequest = request
        self.output = output
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
            output?.didFailAuthorization(with: .missingCode)
            return
        }
        
        webView.stopLoading()
        output?.didReceiveAuthorizationCode(code)
    }
}
