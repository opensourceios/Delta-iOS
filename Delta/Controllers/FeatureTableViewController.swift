//
//  FeatureTableViewController.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import UIKit

class FeatureTableViewController: UITableViewController, FeatureSelectionDelegate, InputChangedDelegate {
    
    var feature: Feature?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cells
        tableView.register(InputTableViewCell.self, forCellReuseIdentifier: "inputCell")
        tableView.register(LabelTableViewCell.self, forCellReuseIdentifier: "outputCell")
    }
    
    func selectFeature(_ feature: Feature?) {
        self.feature = feature
        
        // Update title
        navigationItem.title = feature?.name
        
        // Update inputs
        tableView.reloadData()
        
        // Update result shown on screen
        updateResult()
    }
    
    func inputChanged(_ input: Input?) {
        // Get vars
        if let feature = feature, let input = input {
            // Update the input
            for i in feature.inputs {
                if input.name == i.name {
                    i.expression = input.expression
                }
            }
            
            // Update result shown on screen
            updateResult()
        }
    }
    
    func updateResult() {
        if let feature = feature {
            // Update intermediates
            for i in feature.intermediates {
                i.clear()
            }
            for i in feature.intermediates {
                i.update(with: feature.getAllInputs())
            }
            
            // Refresh the output section
            tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        }
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
        if let feature = feature {
            // Check section
            if indexPath.section == 0 {
                // Get input
                let input = feature.inputs[indexPath.row]
                
                // Create the cell
                return (tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as! InputTableViewCell).with(input: input, delegate: self)
            } else {
                // Get output
                let output = feature.outputs[indexPath.row]
                
                // Create the cell
                return (tableView.dequeueReusableCell(withIdentifier: "outputCell", for: indexPath) as! LabelTableViewCell).with(text: output.toString(with: feature.getAllInputs()))
            }
        }

        return UITableViewCell()
    }

}

protocol InputChangedDelegate: class {
    
    func inputChanged(_ input: Input?)
    
}
