//
//  AppDelegate.swift
//  NavigationTest
//
//  Created by Andrew Oparin on 11.10.2019.
//  Copyright © 2019 Andrew Oparin. All rights reserved.
//

import UIKit
import PinLayout

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?

    private lazy var rootController = ViewController(title: "Root", backgroundColor: .black)
    
    private lazy var rootNavigationController = UINavigationController(rootViewController: rootController)
    
    private var mainCoordinator: MainCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = rootNavigationController
        self.window?.makeKeyAndVisible()
        
        rootController.onPresentNext = { [weak self] in
            self?.startFlow()
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
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

