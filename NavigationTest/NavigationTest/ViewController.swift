//
//  ViewController.swift
//  NavigationTest
//
//  Created by Andrew Oparin on 11.10.2019.
//  Copyright © 2019 Andrew Oparin. All rights reserved.
//

import UIKit
import MXSegmentedPager

class CollectionLayout: UICollectionViewFlowLayout {
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
}

class CollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialSetup() {
        contentView.backgroundColor = .yellow
    }
}

class CollectionView: UICollectionView, UIGestureRecognizerDelegate {
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
//                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return false
//    }
}

class HeaderView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let collectionLayout: CollectionLayout = {
        let collectionViewLayout = CollectionLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 0
        return collectionViewLayout
    }()
    
    lazy var collectionView: CollectionView = {
        
        let collectionView = CollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .black
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    let colors = [UIColor.green, UIColor.orange, UIColor.blue]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialSetup() {
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: String.init(describing: CollectionViewCell.self))
        
        addSubview(collectionView)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: CollectionViewCell.self), for: indexPath) as! CollectionViewCell
        cell.contentView.backgroundColor = colors[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.frame = bounds
        
        let left: CGFloat
        let right: CGFloat
        if #available(iOS 11.0, *) {
            right = safeAreaInsets.right
            left = safeAreaInsets.left
        } else {
            right = 0
            left = 0
        }
        collectionView.frame.origin.x = left
        collectionView.frame.size.width = collectionView.frame.size.width - right - left
        collectionLayout.estimatedItemSize = bounds.size
    }
}

struct StorePageModel {
    let title: String
    let viewController: UIViewController
}

protocol StorePagerViewControllerDelegate: class {
    func shouldScroll(withSubView subView: UIView) -> Bool
}

final class StorePagerViewController: MXSegmentedPagerController {

    weak var delegate: StorePagerViewControllerDelegate?
    
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
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, viewForPageAt index: Int) -> UIView {
        return models[index].viewController.view
    }

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
    
    override func shouldScroll(withSubView subView: UIView) -> Bool {
        return delegate?.shouldScroll(withSubView: subView) ?? true
    }
}

class CollectionVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: String.init(describing: CollectionViewCell.self))
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()

        collectionView.frame = view.bounds
    }
    
    let colors = [UIColor.orange, UIColor.blue, UIColor.orange, UIColor.blue, UIColor.orange, UIColor.blue]
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: CollectionViewCell.self), for: indexPath) as! CollectionViewCell
        cell.contentView.backgroundColor = colors[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.width / 2)
    }
}

class ViewController: UIViewController, StorePagerViewControllerDelegate {
    
    let pagerVC = StorePagerViewController()
    let headerView = HeaderView()
    
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
        print(#function)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(closeHandler))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .fastForward, target: self, action: #selector(presentNextHandler))
        view.backgroundColor = backgroundColor
        
        addChild(pagerVC)
        view.addSubview(pagerVC.view)
        pagerVC.didMove(toParent: self)
        
        headerView.backgroundColor = .red
        pagerVC.segmentedPager.parallaxHeader.view = headerView
        pagerVC.segmentedPager.parallaxHeader.minimumHeight = 150
        pagerVC.segmentedPager.parallaxHeader.height = 300
        pagerVC.segmentedPager.parallaxHeader.mode = .fill
        
        let vc = CollectionVC()
        vc.view.backgroundColor = .black
        let m = StorePageModel(title: "dsfsd", viewController: vc)
        pagerVC.update(models: [m])
        pagerVC.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print(#function)
    }
    
    @available(iOS 11.0, *)
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        print(#function)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print(#function)
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
        print(#function)
        pagerVC.view.frame = view.bounds
    }
    
    @objc func presentNextHandler() {
        onPresentNext?()
    }
    
    func shouldScroll(withSubView subView: UIView) -> Bool {
        return subView != headerView.collectionView
    }
}

