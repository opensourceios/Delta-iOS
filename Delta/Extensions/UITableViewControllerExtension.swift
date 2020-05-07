//
//  UITableViewControllerExtension.swift
//  Delta
//
//  Created by Nathan FALLET on 27/02/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit
import APIRequest

extension UITableViewController {
    
    func reloadData(withStatus status: APIResponseStatus) {
        // Reload tableView
        self.tableView.reloadData()
        
        // Convert to status container
        if let statusContainer = self as? StatusContainerDelegate {
            // Update status label
            if status == .ok || status == .created {
                statusContainer.getStatusLabel().isHidden = true
                statusContainer.getStatusLabel().text = ""
            } else {
                statusContainer.getStatusLabel().text = "status_\(status)".localized()
                statusContainer.getStatusLabel().isHidden = false
            }
        }
        
        // Stop refresh control
        if status != .loading {
            refreshControl?.endRefreshing()
        }
    }
    
}
