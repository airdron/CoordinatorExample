//
//  MainCoordinator.swift
//  NavigationTest
//
//  Created by Andrew Oparin on 01.11.2019.
//  Copyright © 2019 Andrew Oparin. All rights reserved.
//

import UIKit

class MainCoordinator {
    
    private let navigationController: UINavigationController
    
    var onClose: (() -> Void)?
    
    private var nextCoordinator: MainCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showFirst(in: navigationController)
    }
    
    func finish(completion: @escaping (() -> Void)) {
        navigationController.dismiss(animated: true, completion: completion)
    }
    
    func showFirst(in navigationController: UINavigationController) {
        let firstController = ViewController(title: #function, backgroundColor: .green)
        let firstNavigationController = UINavigationController(rootViewController: firstController)
        firstController.onClose = { [weak self] in
            self?.onClose?()
        }
        
        firstController.onPresentNext = { [weak self, weak firstNavigationController] in
            guard let firstNavigationController = firstNavigationController else { return }
            self?.showSecond(in: firstNavigationController)
        }
        navigationController.present(firstNavigationController, animated: true, completion: nil)
    }
    
    func showSecond(in navigationController: UINavigationController) {
        let secondController = ViewController(title: #function, backgroundColor: .blue)
        let secondNavigationController = UINavigationController(rootViewController: secondController)
        
        secondController.onClose = { [weak self] in
            self?.onClose?()
        }
        
        secondController.onPresentNext = { [weak self, weak secondNavigationController] in
            guard let secondNavigationController = secondNavigationController else { return }
            self?.showThird(in: secondNavigationController)
        }
        navigationController.present(secondNavigationController, animated: true, completion: nil)
    }
    
    func showThird(in navigationController: UINavigationController) {
        let thirdController = ViewController(title: #function, backgroundColor: .red)
        let thirdNavigationController = UINavigationController(rootViewController: thirdController)
        
        thirdController.onClose = { [weak self] in
            self?.onClose?()
        }
        
        thirdController.onPresentNext = { [weak self, weak thirdNavigationController] in
            guard let thirdNavigationController = thirdNavigationController else { return }
            self?.nextFlow(in: thirdNavigationController)
        }
        
        navigationController.present(thirdNavigationController, animated: true, completion: nil)
    }
    
    func nextFlow(in navigationController: UINavigationController) {
        nextCoordinator = MainCoordinator(navigationController: navigationController)
        nextCoordinator?.onClose = { [weak nextCoordinator] in
            nextCoordinator?.finish {
                nextCoordinator = nil
            }
        }
        nextCoordinator?.start()
    }
}
