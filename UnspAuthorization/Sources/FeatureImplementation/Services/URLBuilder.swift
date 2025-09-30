//
//  URLBuilder.swift
//  UnspAuthoriztion
//
//  Created by Malik Timurkaev on 27.09.2025.
//

import Foundation

final class URLBuilder {
    private var urlComponents = URLComponents()
    private var components: [URLComponent] = []
    
    @discardableResult
    func scheme(_ value: String) -> Self {
        components.append(.scheme(value))
        return self
    }
    
    @discardableResult
    func host(_ value: String) -> Self {
        components.append(.host(value))
        return self
    }
    
    @discardableResult
    func path(_ value: String) -> Self {
        components.append(.path(value))
        return self
    }
    
    @discardableResult
    func queryItem(name: String, value: String) -> Self {
        components.append(.queryItem(name: name, value: value))
        return self
    }
    
    func build() -> URL? {
        for component in components {
            switch component {
            case .scheme(let scheme):
                urlComponents.scheme = scheme
            case .host(let host):
                urlComponents.host = host
            case .path(let path):
                urlComponents.path += "/" + path
            case .queryItem(let name, let value):
                urlComponents.queryItems?.append(URLQueryItem(name: name, value: value))
            }
            
            #warning("протестить")
//        case .path(let path):
//            if urlComponents.path.isEmpty { urlComponents.path = "/" + path }
//            else { urlComponents.path += "/" + path }
//
//        case .queryItem(let name, let value):
//            var items = urlComponents.queryItems ?? []
//            items.append(URLQueryItem(name: name, value: value))
//            urlComponents.queryItems = items

        }
        
        return urlComponents.url
    }
    
    private enum URLComponent {
        case scheme(String)
        case host(String)
        case path(String)
        case queryItem(name: String, value: String)
    }
}
