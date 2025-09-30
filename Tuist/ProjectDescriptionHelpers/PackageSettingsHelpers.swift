//
//  File.swift
//  Manifests
//
//  Created by Malik Timurkaev on 26.09.2025.
//

import ProjectDescription

public func resolvedFramework() -> ProjectDescription.Product {
    if case let .string(v) = Environment.productType {
        switch v.lowercased() {
        case "static":
            return .staticFramework
        default:
            return .framework
        }
    }
    return .framework
}
