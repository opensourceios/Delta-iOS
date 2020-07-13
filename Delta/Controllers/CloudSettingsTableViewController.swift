//
//  CloudSettingsTableViewController.swift
//  Delta
//
//  Created by Nathan FALLET on 13/07/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

class CloudSettingsTableViewController: UITableViewController {
    
    let algorithm: Algorithm
    let completionHandler: (Algorithm) -> ()
    
    var `public`: Bool?
    var notes: String?
    
    init(algorithm: Algorithm, completionHandler: @escaping (Algorithm) -> ()) {
        self.algorithm = algorithm
        self.completionHandler = completionHandler
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Navigation bar
        navigationItem.title = "cloud_settings_title".localized()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "close".localized(), style: .plain, target: self, action: #selector(close(_:)))
        
        // Register cells
        tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: "switchCell")
        
        // Make cells auto sizing
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        // Fetch metadatas
        fetchMetadatas()
    }
    
    func fetchMetadatas() {
        // Call API
        APIAlgorithm(id: algorithm.remote_id, name: nil, owner: nil, last_update: nil, lines: nil, notes: nil, icon: nil, public: nil).fetchMissingData { data, status in
            // Check response
            if let data = data {
                // Update data
                self.public = data.public
                self.notes = data.notes
            }
            
            // Refresh table view
            self.tableView.reloadData()
        }
    }
    
    func sendMetadatas() {
        // Create an alert (for progress)
        let alert = UIAlertController(title: "status_uploading".localized(), message: nil, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        
        // Start uploading
        algorithm.toAPIAlgorithm(public: `public` ?? false, notes: notes ?? "").upload { data, status in
            // Remove alert
            alert.dismiss(animated: true, completion: nil)
            
            // Check data
            if let data = data, status == .ok || status == .created {
                // Transform returned data
                self.algorithm.remote_id = data.id
                self.public = data.public
                self.notes = data.notes
                
                // Send back new data
                self.completionHandler(self.algorithm)
            }
            
            // Refresh table view
            self.tableView.reloadData()
        }
    }
    
    @objc func close(_ sender: UIBarButtonItem) {
        // Dismiss view controller
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return algorithm.remote_id != nil ? 2 : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 || section == 1 ? 1 : 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "cloud_settings_sync_title".localized() : "cloud_settings_public_title".localized()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Visibility
        if indexPath.section == 1 {
            return (tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SwitchTableViewCell).with(text: "cloud_settings_public".localized(), enabled: `public`, onChange: publicChanged)
        }
        
        // Cell to enable/disable cloud sync
        return (tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SwitchTableViewCell).with(text: "cloud_settings_sync".localized(), enabled: algorithm.remote_id != nil, onChange: syncChanged)
    }
    
    // MARK: - Handlers
    
    func syncChanged(enabled: Bool) {
        // Check if switch is enabled
        if enabled {
            // Upload
            sendMetadatas()
        }
    }
    
    func publicChanged(enabled: Bool) {
        // Update value
        self.public = enabled
        
        // Send metadatas
        self.sendMetadatas()
    }

}
