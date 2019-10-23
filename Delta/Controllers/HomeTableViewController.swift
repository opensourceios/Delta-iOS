//
//  HomeTableViewController.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController, AlgorithmsChangedDelegate {
    
    weak var delegate: AlgorithmSelectionDelegate?
    var myalgorithms = [Algorithm]()
    var downloads = [Algorithm]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation bar
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        navigationItem.title = "name".localized()
        
        // Register cells
        tableView.register(AlgorithmTableViewCell.self, forCellReuseIdentifier: "algorithmCell")
        tableView.register(LabelTableViewCell.self, forCellReuseIdentifier: "labelCell")
        
        // Load algorithms
        loadAlgorithms()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
    
    func loadAlgorithms() {
        // Clear previous data
        myalgorithms = []
        downloads = []
        
        // Retrieve algorithms from database
        let algorithms = Database.current.getAlgorithms()
        
        // Iterate them
        for algorithm in algorithms {
            // Check if owned or downloaded
            if algorithm.owner {
                // Add to My algorithms
                myalgorithms.append(algorithm)
            } else {
                // Add to Downloads
                downloads.append(algorithm)
            }
        }
        
        // If downloads are empty, add defaults
        if downloads.isEmpty {
            // TODO: download them from API and save them
            for algorithm in Algorithm.defaults {
                // Save it locally
                let _ = Database.current.addAlgorithm(algorithm)
            }
            
            // Reload algorithms
            loadAlgorithms()
        }
        
        // Update tableView
        tableView.reloadData()
    }
    
    func algorithmsChanged() {
        // Upload algorithm list
        loadAlgorithms()
    }

    // TableView management

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? myalgorithms.count + 1 : section == 1 ? downloads.count : 3
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "myalgorithms".localized() : section == 1 ? "downloads".localized() : "about".localized()
    }
    
    #if !targetEnvironment(macCatalyst)
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return section == 2 ? "donate_description".localized() : ""
    }
    #endif

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Check for section
        if indexPath.section == 0 {
            // Check for new cell
            if indexPath.row == myalgorithms.count {
                // Create new cell
                return (tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelTableViewCell).with(text: "new".localized(), accessory: .disclosureIndicator)
            }
            
            // Get algorithm
            let algorithm = myalgorithms[indexPath.row]
            
            // Create cell
            return (tableView.dequeueReusableCell(withIdentifier: "algorithmCell", for: indexPath) as! AlgorithmTableViewCell).with(algorithm: algorithm)
        } else if indexPath.section == 1 {
            // Get algorithm
            let algorithm = downloads[indexPath.row]
            
            // Create cell
            return (tableView.dequeueReusableCell(withIdentifier: "algorithmCell", for: indexPath) as! AlgorithmTableViewCell).with(algorithm: algorithm)
        } else {
            if indexPath.row == 0 {
                // About
                return (tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelTableViewCell).with(text: "about".localized(), accessory: .disclosureIndicator)
            } else if indexPath.row == 1 {
                // Help and documentation
                return (tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelTableViewCell).with(text: "help".localized(), accessory: .disclosureIndicator)
            } else if indexPath.row == 2 {
                // Donate
                return (tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelTableViewCell).with(text: "donate".localized(), accessory: .disclosureIndicator)
            }
        }
        
        fatalError("Unknown cell!")
    }
    
    // Navigation management
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Check for section
        if indexPath.section == 0 {
            // Check for new cell
            if indexPath.row == myalgorithms.count {
                // Create an editor
                let editor = EditorTableViewController(algorithm: Algorithm(local_id: 0, remote_id: nil, owner: true, name: "new".localized(), last_update: Date(), root: RootAction([]))) { newAlgorithm in
                    // Update with new algorithm
                    self.loadAlgorithms()
                }
                
                // Show it
                present(UINavigationController(rootViewController: editor), animated: true, completion: nil)
                
                // Stop here
                return
            }
            
            // Get selected algorithm
            let algorithm = myalgorithms[indexPath.row]
            
            // Update the delegate
            delegate?.selectAlgorithm(algorithm)
            
            // Show view controller
            if let algorithmVC = delegate as? AlgorithmTableViewController, let algorithmNavigation = algorithmVC.navigationController {
                splitViewController?.showDetailViewController(algorithmNavigation, sender: nil)
            }
        } else if indexPath.section == 1 {
            // Get selected algorithm
            let algorithm = downloads[indexPath.row]
            
            // Update the delegate
            delegate?.selectAlgorithm(algorithm)
            
            // Show view controller
            if let algorithmVC = delegate as? AlgorithmTableViewController, let algorithmNavigation = algorithmVC.navigationController {
                splitViewController?.showDetailViewController(algorithmNavigation, sender: nil)
            }
        } else {
            if indexPath.row == 0 {
                // About
                let alert = UIAlertController(title: "about".localized(), message: "about_text".localized(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok".localized(), style: .default, handler: nil))
                UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
            } else if indexPath.row == 1 {
                // Help and documentation
                if let url = URL(string: "https://www.delta-math-helper.com") {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            } else if indexPath.row == 2 {
                // Donate
                if let url = URL(string: "https://www.paypal.me/NathanFallet") {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        }
    }
    
    // Editing support for custom algorithms

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (indexPath.section == 0 && indexPath.row != myalgorithms.count) || (indexPath.section == 1 && indexPath.row != downloads.count)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "delete".localized()) { (action, indexPath) in
            // Define algorithm
            let algorithm: Algorithm
            
            // Check for section
            if indexPath.section == 0 {
                // Get selected algorithm
                algorithm = self.myalgorithms[indexPath.row]
            } else {
                // Get selected algorithm
                algorithm = self.downloads[indexPath.row]
            }
            
            // Delete it from database
            Database.current.deleteAlgorithm(algorithm)
            
            // Update without algorithm
            self.loadAlgorithms()
        }
        delete.backgroundColor = .systemRed
        
        let edit = UITableViewRowAction(style: .normal, title: "edit".localized()) { (action, indexPath) in
            // Define algorithm
            let algorithm: Algorithm
            
            // Check for section
            if indexPath.section == 0 {
                // Get selected algorithm
                algorithm = self.myalgorithms[indexPath.row]
            } else {
                // Get selected algorithm
                algorithm = self.downloads[indexPath.row]
            }
            
            // Create an editor
            let editor = EditorTableViewController(algorithm: algorithm) { newAlgorithm in
                // Update with new algorithm
                self.loadAlgorithms()
            }
            
            // Show it
            self.present(UINavigationController(rootViewController: editor), animated: true, completion: nil)
        }
        edit.backgroundColor = .systemBlue
        
        return [delete, edit]
    }

}

protocol AlgorithmSelectionDelegate: class {
    
    func selectAlgorithm(_ algorithm: Algorithm?)
    
}
