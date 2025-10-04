// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let appName = "UnspAuthorization"

let package = Package(
    name: appName,
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: appName,
            type: .dynamic,
            targets: [appName]
        ),
    ],
    dependencies: [
        .make(from: SPMDependency.valet),
        .make(from: SPMDependency.snapKit),
        .make(from: SPMDependency.fontsKit),
        .make(from: SPMDependency.loggingKit),
        .make(from: SPMDependency.keychainStorageKit)
    ],
    targets: [
        .target(
            name: appName,
            dependencies: [
                .product(SPMDependency.valet.name),
                .product(SPMDependency.snapKit.name),
                .product(SPMDependency.fontsKit.name),
                .product(SPMDependency.loggingKit.name),
                .product(SPMDependency.keychainStorageKit.name)
            ],
            path: appName,
            sources: ["Sources"]
        )
    ]
)


/// MARK: - Dependencies
fileprivate enum SPMDependency {
    static let valet = PackageModel(
        name: "Valet",
        url: "https://github.com/square/Valet.git",
        requirement: .version(.init(5, 0, 0))
    )
    
    static let loggingKit = PackageModel(
        name: "LoggingKit",
        url: "https://github.com/TimurkaevMalik/LoggingKit.git",
        requirement: .version(.init(1, 1, 0))
    )
    
    static let keychainStorageKit = PackageModel(
        name: "KeychainStorageKit",
        url: "https://github.com/TimurkaevMalik/KeychainStorageKit.git",
        requirement: .version(.init(1, 1, 3))
    )
    
    static let fontsKit = PackageModel(
        name: "FontsKit",
        url: "https://github.com/TimurkaevMalik/FontsKit.git",
        requirement: .version(.init(1, 1, 0))
    )
    
    static let snapKit = PackageModel(
        name: "SnapKit",
        url: "https://github.com/SnapKit/SnapKit.git",
        requirement: .version(.init(5, 7, 0))
    )
}

/// MARK: - PackageModel
fileprivate struct PackageModel: Sendable {
    let name: String
    let url: String
    let requirement: Requirement
    
    init(name: String, url: String, requirement: Requirement) {
        self.name = name
        self.url = url
        self.requirement = requirement
    }
    
    public enum Requirement: Sendable{
        case version(Version)
        case branch(String)
        
        var string: String {
            switch self {
                
            case .version(let version):
                return version.stringValue
                
            case .branch(let string):
                return string
            }
        }
    }
}

/// MARK: - Version
fileprivate extension Version {
    var stringValue: String {
        let major = "\(major)"
        let minor = "\(minor)"
        let patch = "\(patch)"
        
        return major + "." + minor + "." + patch
    }
    
    init(string: String) {
        self.init(stringLiteral: string)
    }
}

/// MARK: - Package.Dependency
fileprivate extension Package.Dependency {
    static func make(from package: PackageModel) -> Package.Dependency {
        let url = package.url
        let requirement = package.requirement.string
        
        switch package.requirement {
            
        case .version:
            return .package(url: url, from: .init(string: requirement))
        case .branch:
            return .package(url: url, branch: requirement)
        }
    }
}

/// MARK: - Target.Dependency
fileprivate extension Target.Dependency {
    static func product(_ name: String) -> Self {
        .product(name: name, package: name)
    }
}
