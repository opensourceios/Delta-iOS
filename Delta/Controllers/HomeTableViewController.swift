//
//  HomeTableViewController.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    weak var delegate: AlgorithmSelectionDelegate?
    var algorithms = Algorithm.array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation bar
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        navigationItem.title = "name".localized()
        
        // Register cells
        tableView.register(LabelTableViewCell.self, forCellReuseIdentifier: "labelCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }

    // TableView management
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? algorithms.count : 3
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "algorithms".localized() : "about".localized()
    }
    
    #if !targetEnvironment(macCatalyst)
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return section == 0 ? "more_soon".localized() : "donate_description".localized()
    }
    #endif

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Check for section
        if indexPath.section == 0 {
            // Get algorithm
            let algorithm = algorithms[indexPath.row]
            
            // Create cell
            return (tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelTableViewCell).with(text: algorithm.name, accessory: .disclosureIndicator)
        } else {
            if indexPath.row == 0 {
                // About
                return (tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelTableViewCell).with(text: "about".localized(), accessory: .disclosureIndicator)
            } else if indexPath.row == 1 {
                // More about our team
                return (tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelTableViewCell).with(text: "moreAboutOurTeam".localized(), accessory: .disclosureIndicator)
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
            // Get selected algorithm
            let algorithm = algorithms[indexPath.row]
            
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
                // More about our team
                if let url = URL(string: "https://www.groupe-minaste.org") {
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}

protocol AlgorithmSelectionDelegate: class {
    
    func selectAlgorithm(_ algorithm: Algorithm?)
    
}
