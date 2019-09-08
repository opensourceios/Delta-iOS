//
//  SplitViewController.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    let leftViewController = HomeTableViewController(style: .grouped)
    let rightViewController = FeatureTableViewController(style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftViewController.delegate = rightViewController

        viewControllers = [
            UINavigationController(rootViewController: leftViewController),
            UINavigationController(rootViewController: rightViewController)
        ]
        
        preferredDisplayMode = .allVisible
        delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }

}
