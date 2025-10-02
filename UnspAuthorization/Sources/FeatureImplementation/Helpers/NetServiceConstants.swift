//
//  Host.swift
//  UnspAuthoriztion
//
//  Created by Malik Timurkaev on 27.09.2025.
//


import Foundation

///TODO: move Scheme and Host to a separate module
enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}

enum Scheme: String {
    case https
}

enum Host: String {
    case unsplash = "unsplash.com"
}

enum Path: String {
    case oauth
    case token
    case authorize
    
    static func build(_ paths: [Path]) -> String {
        paths.map({ $0.rawValue }).joined(separator: "/")
    }
}
enum AuthConstants {
    static let clientID = "Ix8DGsN3icXmar5IMI1Hwy0G2L8MotFf93HczcjVPOk"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let authorizationCode = "authorization_code"
}

enum QueryItemNames: String {
    case clientID = "client_id"
    case grantType = "grant_type"
    case redirectURI = "redirect_uri"
    case responseType = "response_type"
    case scope = "scope"
    case code = "code"
}

enum AccessScope: String {
    case `public` = "public"
    case readUser = "read_user"
    case writeLikes = "write_likes"
}
