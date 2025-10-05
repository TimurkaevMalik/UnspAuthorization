//
//  SceneDelegate.swift
//  FeatureTemplate
//
//  Created by Malik Timurkaev on 26.09.2025.
//


import UIKit
import CoreKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var rootCoordinator: Coordinator?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let navigation = UINavigationController()
        let coordinator = RootUnspAuthCoordinator(navigation: navigation)
        rootCoordinator = coordinator
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigation
        coordinator.start()
        window?.makeKeyAndVisible()
    }
}
