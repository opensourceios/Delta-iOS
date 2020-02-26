//
//  CloudHomeTableViewController.swift
//  Delta
//
//  Created by Nathan FALLET on 26/02/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

class CloudHomeTableViewController: UITableViewController, UISearchBarDelegate {
    
    weak var delegate: CloudAlgorithmSelectionDelegate?
    var algorithms = [APIAlgorithm]()
    var search = ""
    var searchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Navigation bar
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "cloud".localized()
        
        // Register cells
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "homeCell")
        
        // Search controller
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        // Load algorithms
        loadAlgorithms()
    }
    
    func loadAlgorithms() {
        // Load algorithms from API
        APIRequest("GET", path: "/algorithm/search.php").with(name: "search", value: search).execute([APIAlgorithm].self) { data, status in
            if let data = data {
                // Update data
                self.algorithms = data
                
                // Refresh tableView
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Update search
        search = searchBar.text ?? ""
        
        // Reload algorithms
        loadAlgorithms()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Update search
        search = ""
        
        // Reload algorithms
        loadAlgorithms()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return algorithms.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "cloud_algorithms".localized()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get algorithm
        let algorithm = algorithms[indexPath.row]
        
        // Create cell
        return (tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeTableViewCell).with(algorithm: algorithm)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get selected algorithm
        let algorithm = algorithms[indexPath.row]
        
        // Update the delegate
        delegate?.selectAlgorithm(algorithm)
        
        // Show view controller
        if let algorithmVC = delegate as? CloudDetailsTableViewController, let algorithmNavigation = algorithmVC.navigationController {
            splitViewController?.showDetailViewController(algorithmNavigation, sender: nil)
        }
    }

}

protocol CloudAlgorithmSelectionDelegate: class {
    
    func selectAlgorithm(_ algorithm: APIAlgorithm?)
    
}
