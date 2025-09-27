// swift-tools-version: 6.0
import PackageDescription

///MARK: - PackageSettings
#if TUIST
import struct ProjectDescription.PackageSettings
import enum ProjectDescription.Product
import enum ProjectDescription.Environment
import ProjectDescriptionHelpers

let packageSettings = PackageSettings(
    productTypes: [:]
)
#endif

/// MARK: - Package
let package = Package(
    name: "UnspAuthoriztion",
    dependencies: []
)

/// MARK: - Dependencies
fileprivate enum SPMDependency {}

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
}
