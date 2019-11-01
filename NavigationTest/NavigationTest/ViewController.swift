//
//  ViewController.swift
//  NavigationTest
//
//  Created by Andrew Oparin on 11.10.2019.
//  Copyright © 2019 Andrew Oparin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var onClose: (() -> Void)?
    var onPresentNext: (() -> Void)?

    private let backgroundColor: UIColor
    
    init(title: String, backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .close, target: self, action: #selector(closeHandler))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .fastForward, target: self, action: #selector(presentNextHandler))
        view.backgroundColor = backgroundColor
    }
        
    @objc func closeHandler() {
        onClose?()
    }
    
    @objc func presentNextHandler() {
        onPresentNext?()
    }
}

