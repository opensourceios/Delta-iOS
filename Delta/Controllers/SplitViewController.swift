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
    let rightViewController = AlgorithmTableViewController(style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Give delegates
        leftViewController.delegate = rightViewController
        rightViewController.delegate = leftViewController
        
        // Create navigation controllers
        let leftNavigationController = UINavigationController(rootViewController: leftViewController)
        let rightNavigationController = UINavigationController(rootViewController: rightViewController)

        // Assign them
        viewControllers = [leftNavigationController, rightNavigationController]
        
        // Some configuration
        preferredDisplayMode = .allVisible
        delegate = self
        
        if #available(iOS 13.0, *) {
            // Special color for Catalyst
            primaryBackgroundStyle = .sidebar
        }
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }

}
