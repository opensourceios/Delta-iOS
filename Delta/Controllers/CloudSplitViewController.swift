//
//  CloudSplitViewController.swift
//  Delta
//
//  Created by Nathan FALLET on 26/02/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

class CloudSplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    let leftViewController = CloudHomeTableViewController(style: .grouped)
    let rightViewController = CloudDetailsTableViewController(style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Give delegates
        leftViewController.delegate = rightViewController
        
        // Create navigation controllers
        let leftNavigationController = UINavigationController(rootViewController: leftViewController)
        let rightNavigationController = UINavigationController(rootViewController: rightViewController)

        // Assign them
        viewControllers = [leftNavigationController, rightNavigationController]
        
        // Some configuration
        preferredDisplayMode = .allVisible
        delegate = self
        
        // To close the cloud
        leftViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cancel".localized(), style: .plain, target: self, action: #selector(close(_:)))
        
        if #available(iOS 13.0, *) {
            // Special color for Catalyst
            primaryBackgroundStyle = .sidebar
        }
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    @objc func close(_ sender: UIBarButtonItem) {
        // Dismiss view controller
        dismiss(animated: true, completion: nil)
    }

}
