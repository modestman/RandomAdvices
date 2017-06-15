//
//  ViewController.swift
//  RandomAdvices
//
//  Created by Anton Glezman on 14.06.17.
//  Copyright © 2017 Globus. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    enum Tabs: Int {
        case advice = 0
        case favorites = 1
    }
    
    private var currentTab = Tabs.advice
    private var currentViewController: UIViewController?
    
    private lazy var adviceViewController: AdviceViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "AdviceViewController") as! AdviceViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var favoritesViewController: FavoritesViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "FavoritesViewController") as! FavoritesViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private func add(asChildViewController viewController: UIViewController) {
        self.addChildViewController(viewController)
        self.containerView.addSubview(viewController.view)
        viewController.view.frame = self.containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
    }

    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateView()
    }
    
    private func updateView() {
        switch self.currentTab {
        case .advice:
            remove(asChildViewController: favoritesViewController)
            add(asChildViewController: adviceViewController)
        case .favorites:
            remove(asChildViewController: adviceViewController)
            add(asChildViewController: favoritesViewController)
        }
    }
    
    // MARK: - Actions

    @IBAction func changeSegmentedControl(_ sender: UISegmentedControl) {
        guard let newTab = Tabs(rawValue: sender.selectedSegmentIndex) else { return }
        self.currentTab = newTab
        self.updateView()
    }
  
}

