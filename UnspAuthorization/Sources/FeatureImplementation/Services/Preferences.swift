//
//  Preferences.swift
//  UnspAuthorization
//
//  Created by Malik Timurkaev on 03.10.2025.
//

import Foundation

//#warning("Move to CoreKit")
//protocol PreferencesProtocol {
//    func set(_ value: Any?, forKey key: String)
//    func retrieve<T: Codable>(_ type: T.Type, forKey key: String) -> T?
//    func removeObject(forKey key: String)
//}
//
//extension UserDefaults: PreferencesProtocol {
//    
//    func retrieve<T: Codable>(
//        _ type: T.Type = T.self,
//        forKey key: String
//    ) -> T? {
//        
//        switch T.self {
//        case is String.Type:  return string(forKey: key) as? T
//        case is Int.Type:     return integer(forKey: key) as? T
//        case is Double.Type:  return double(forKey: key) as? T
//        case is Bool.Type:    return bool(forKey: key) as? T
//        case is Date.Type:    return object(forKey: key) as? T
//        case is Data.Type:    return data(forKey: key) as? T
//        case is URL.Type:     return url(forKey: key) as? T
//        default:
//            if let data = data(forKey: key) {
//                do {
//                    return try? JSONDecoder().decode(T.self, from: data)
//                }
//            }
//            return object(forKey: key) as? T
//        }
//    }
//}
