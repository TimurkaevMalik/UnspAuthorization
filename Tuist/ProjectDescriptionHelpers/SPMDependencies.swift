//
//  SPMDependency.swift
//  Manifests
//
//  Created by Malik Timurkaev on 26.09.2025.
//


import ProjectDescription


public enum SPMDependency {}

public struct PackageModel: Sendable {
    public let name: String
    public let url: String
    public let requirement: Requirement
    
    init(name: String, url: String, requirement: Requirement) {
        self.name = name
        self.url = url
        self.requirement = requirement
    }
    
    public enum Requirement: Sendable{
        case version(Version)
        case branch(String)
        
        public var string: String {
            switch self {
                
            case .version(let version):
                return version.stringValue
                
            case .branch(let string):
                return string
            }
        }
    }
}

extension Version {
    var stringValue: String {
        let major = "\(major)"
        let minor = "\(minor)"
        let patch = "\(patch)"
        
        return major + "." + minor + "." + patch
    }
}
