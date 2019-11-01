//
//  SceneDelegate.swift
//  NavigationTest
//
//  Created by Andrew Oparin on 11.10.2019.
//  Copyright © 2019 Andrew Oparin. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private lazy var rootController = ViewController(title: "Root", backgroundColor: .black)
    
    private lazy var rootNavigationController = UINavigationController(rootViewController: rootController)
    
    private var mainCoordinator: MainCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)
        self.window?.rootViewController = rootNavigationController
        self.window?.makeKeyAndVisible()
        
        rootController.onPresentNext = { [weak self] in
            self?.startFlow()
        }
    }
    
    func startFlow() {
        mainCoordinator = MainCoordinator(navigationController: rootNavigationController)
        
        mainCoordinator?.onClose = { [weak mainCoordinator] in
            mainCoordinator?.finish {
                mainCoordinator = nil
            }
        }
        
        mainCoordinator?.start()
    }
}

