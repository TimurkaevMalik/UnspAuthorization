// swift-tools-version: 6.0
import PackageDescription

///MARK: - PackageSettings
#if TUIST
import struct ProjectDescription.PackageSettings
import enum ProjectDescription.Product
import enum ProjectDescription.Environment
import ProjectDescriptionHelpers

let packageSettings = PackageSettings(
    productTypes: [SPMDependency.valet.name: .framework]
)
#endif

/// MARK: - Package
let package = Package(
    name: "UnspAuthoriztion",
    dependencies: [
        .make(from: SPMDependency.valet)
    ]
)

/// MARK: - Dependencies
fileprivate enum SPMDependency {
    static let valet = PackageModel(
        name: "Valet",
        url: "https://github.com/square/Valet.git",
        requirement: .version(.init(5, 0, 0)))
}

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
