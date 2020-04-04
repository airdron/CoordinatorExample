//
//  ViewController.swift
//  NavigationTest
//
//  Created by Andrew Oparin on 11.10.2019.
//  Copyright © 2019 Andrew Oparin. All rights reserved.
//

import UIKit
import MXSegmentedPager

struct StorePageModel {
    let title: String
    let viewController: UIViewController
}

final class StorePagerViewController: MXSegmentedPagerController {

    private var models: [StorePageModel] = [StorePageModel(title: "", viewController: UIViewController())]

    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedPager.backgroundColor = Styles.backgroundColor
        segmentedPager.segmentedControlPosition = .top
        segmentedPager.segmentedControlEdgeInsets = .zero
        segmentedPager.segmentedControl.segmentEdgeInset = .zero
        segmentedPager.segmentedControl.selectionStyle = .fullWidthStripe
        segmentedPager.segmentedControl.selectionIndicatorLocation = .none
        segmentedPager.segmentedControl.backgroundColor = Styles.backgroundColor
        segmentedPager.segmentedControl.titleTextAttributes = Styles.unselectedTitleAttributes
        segmentedPager.segmentedControl.selectedTitleTextAttributes = Styles.selectedTitleAttributes
        segmentedPager.segmentedControl.selectionIndicatorColor = Styles.lineColor
    }

    func update(models: [StorePageModel]) {
        models.forEach { $0.viewController.willMove(toParent: nil) }
        models.forEach { $0.viewController.removeFromParent() }
        self.models = models
        self.segmentedPager.reloadData()
        if !self.models.isEmpty {
            self.segmentedPager.pager.showPage(at: 0, animated: false)
        }
    }

    override func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int {
        return models.count
    }

    override func segmentedPager(_ segmentedPager: MXSegmentedPager, viewControllerForPageAt index: Int) -> UIViewController {
        return models[index].viewController
    }
//    
//    override func segmentedPager(_ segmentedPager: MXSegmentedPager, viewForPageAt index: Int) -> UIView {
//        return models[index].viewController.view
//    }

    override func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        return models[index].title
    }

    private struct Styles {
        static let backgroundColor: UIColor = .white
        static let lineColor: UIColor = .blue

        private static let selectedTitleFontColor: UIColor = .black
        private static let unselectedTitleFontColor: UIColor = .gray

        private static let titleFont = UIFont.systemFont(ofSize: 15)

        static let selectedTitleAttributes: [NSAttributedString.Key: Any] = makeTitleAttributes(with: selectedTitleFontColor)
        static let unselectedTitleAttributes: [NSAttributedString.Key: Any] = makeTitleAttributes(with: unselectedTitleFontColor)

        private static func makeTitleAttributes(with fontColor: UIColor) -> [NSAttributedString.Key: Any] {
            return [NSAttributedString.Key.font: titleFont,
                    NSAttributedString.Key.foregroundColor: fontColor
            ]
        }
    }

    // Пока вкладки отключены, не показываем segmented control
    override func heightForSegmentedControl(in segmentedPager: MXSegmentedPager) -> CGFloat {
        return 0
    }
}

class ViewController1: UIViewController {
   

    private let backgroundColor: UIColor
    
    let sview = UIView()
    
    let customTitle: String
    
    init(title: String, backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.customTitle = title
        super.init(nibName: nil, bundle: nil)
        self.title = customTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear " + customTitle)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        title = customTitle
        print("viewDidAppear " + customTitle)
    }
}

class ViewController: UIViewController {
    
    let secondController = ViewController1(title: "ViewController1", backgroundColor: .blue)
    let pagerVC = StorePagerViewController()
    
    var onClose: (() -> Void)?
    var onPresentNext: (() -> Void)?

    private let backgroundColor: UIColor
    let customTitle: String
    
    init(title: String, backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.customTitle = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(closeHandler))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .fastForward, target: self, action: #selector(presentNextHandler))
        view.backgroundColor = backgroundColor
//        addChild(pagerVC)
//        pagerVC.segmentedPager.parallaxHeader.height = 200
//        let pview = UIView()
//        pview.backgroundColor = .yellow
//        pagerVC.segmentedPager.parallaxHeader.view = pview
//        view.addSubview(pagerVC.view)
//        pagerVC.didMove(toParent: self)
        
//        DispatchQueue.main.async {
//            self.pagerVC.update(models: [StorePageModel(title: "", viewController: self.secondController)])
//        }
        DispatchQueue.main.async {
            self.addChild(self.secondController)
            self.view.addSubview(self.secondController.view)
            self.secondController.didMove(toParent: self)
        }
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
        
    @objc func closeHandler() {
        onClose?()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = customTitle
        
        
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pagerVC.view.frame = view.bounds
    }
    
    @objc func presentNextHandler() {
        onPresentNext?()
    }
}

