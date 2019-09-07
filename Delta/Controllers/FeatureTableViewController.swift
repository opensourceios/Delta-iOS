//
//  FeatureTableViewController.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import UIKit

class FeatureTableViewController: UITableViewController, FeatureSelectionDelegate {
    
    var feature: Feature?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cells
        tableView.register(InputTableViewCell.self, forCellReuseIdentifier: "inputCell")
        tableView.register(LabelTableViewCell.self, forCellReuseIdentifier: "outputCell")
    }
    
    func selectFeature(_ feature: Feature?) {
        self.feature = feature
        
        navigationItem.title = feature?.name
        
        tableView.reloadData()
    }

    // TableView management
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return feature != nil ? 2 : 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? feature?.inputs.count ?? 0 : feature?.outputs.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Inputs" : "Outputs"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Check section
        if indexPath.section == 0 {
            // Get input
            if let input = feature?.inputs[indexPath.row] {
                // Create the cell
                return (tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as! InputTableViewCell).with(text: input)
            }
        } else {
            // Get output
            if let output = feature?.outputs[indexPath.row] {
                // Create the cell
                return (tableView.dequeueReusableCell(withIdentifier: "outputCell", for: indexPath) as! LabelTableViewCell).with(text: output)
            }
        }

        return UITableViewCell()
    }

}
