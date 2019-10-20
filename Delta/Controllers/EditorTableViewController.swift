//
//  EditorTableViewController.swift
//  Delta
//
//  Created by Nathan FALLET on 20/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import UIKit

class EditorTableViewController: UITableViewController {
    
    let algorithm: Algorithm
    
    init(algorithm: Algorithm) {
        self.algorithm = algorithm
        
        if #available(iOS 13, *) {
            super.init(style: .insetGrouped)
        } else {
            super.init(style: .grouped)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enable editing
        tableView.setEditing(true, animated: false)
        
        // Navigation bar
        navigationItem.title = "editor".localized()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "close".localized(), style: .plain, target: self, action: #selector(close(_:)))
        
        // Register cells
        tableView.register(OutputTableViewCell.self, forCellReuseIdentifier: "outputCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? algorithm.inputs.count : algorithm.toLocalizedStrings().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // Get input
            let variable = Array(algorithm.inputs.sorted{ return $0.key < $1.key })[indexPath.row]
            let string = "\(variable.key) = \(variable.value.toString())"
            
            // Return cell
            return (tableView.dequeueReusableCell(withIdentifier: "outputCell", for: indexPath) as! OutputTableViewCell).with(text: string)
        } else {
            // Get action
            let string = algorithm.toLocalizedStrings()[indexPath.row]
            
            // Return cell
            return (tableView.dequeueReusableCell(withIdentifier: "outputCell", for: indexPath) as! OutputTableViewCell).with(text: string)
        }
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    @objc func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
