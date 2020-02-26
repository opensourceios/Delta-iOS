//
//  CloudDetailsTableViewController.swift
//  Delta
//
//  Created by Nathan FALLET on 26/02/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

class CloudDetailsTableViewController: UITableViewController, CloudAlgorithmSelectionDelegate {

    var status: APIResponseStatus = .ok
    var algorithm: APIAlgorithm?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cells
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "homeCell")
    }
    
    func selectAlgorithm(_ algorithm: APIAlgorithm?) {
        // Set status to loading
        self.status = .loading
        
        // Update tableView
        self.tableView.reloadData()
        
        // Fetch data
        algorithm?.fetchMissingData() { data, status in
            // Update status
            self.status = status
            
            // Check data
            if let data = data {
                // Set algorithm
                self.algorithm = data
                
                // Update navigation bar
                self.navigationItem.title = data.name
                self.navigationItem.rightBarButtonItem?.isEnabled = algorithm != nil
            }
            
            // Update tableView
            self.tableView.reloadData()
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return algorithm != nil ? 1 : 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let algorithm = algorithm {
            // Create cell
            return (tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeTableViewCell).with(algorithm: algorithm)
        }
        
        fatalError("Data not found")
    }

}
