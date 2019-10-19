//
//  AlgorithmTableViewController.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import UIKit

class AlgorithmTableViewController: UITableViewController, AlgorithmSelectionDelegate, InputChangedDelegate {
    
    var algorithm: Algorithm?
    var currentOutputs = [Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cells
        tableView.register(InputTableViewCell.self, forCellReuseIdentifier: "inputCell")
        tableView.register(OutputTableViewCell.self, forCellReuseIdentifier: "outputCell")
    }
    
    func selectAlgorithm(_ algorithm: Algorithm?) {
        self.algorithm = algorithm
        
        // Update title
        navigationItem.title = algorithm?.name
        
        // Deselect active fields
        for cell in tableView.visibleCells {
            if let inputCell = cell as? InputTableViewCell {
                inputCell.endEditing(true)
            }
        }
        
        // Update inputs
        tableView.reloadData()
        
        // Update result shown on screen
        updateResult()
    }
    
    func inputChanged(_ input: Input?) {
        // Get vars
        if let algorithm = algorithm, let input = input {
            // Update the input
            algorithm.inputs[input.name] = input.expression
            
            // Update result shown on screen
            updateResult()
        }
    }
    
    func updateResult() {
        if let algorithm = algorithm {
            // Execute algorithm
            let process = algorithm.execute()
            currentOutputs = process.outputs
            
            // Refresh the output section
            tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        }
    }

    // TableView management

    override func numberOfSections(in tableView: UITableView) -> Int {
        return algorithm != nil ? 2 : 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? algorithm?.inputs.count ?? 0 : currentOutputs.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "inputs".localized() : "outputs".localized()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let algorithm = algorithm {
            // Check section
            if indexPath.section == 0 {
                // Get input
                let variable = Array(algorithm.inputs.sorted{ return $0.key < $1.key })[indexPath.row]
                
                // Create the cell
                return (tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as! InputTableViewCell).with(input: Input(name: variable.key, expression: variable.value ), delegate: self)
            } else {
                // Get output
                let output = currentOutputs[indexPath.row]
                
                // Create the cell
                if let output = output as? String {
                    return (tableView.dequeueReusableCell(withIdentifier: "outputCell", for: indexPath) as! OutputTableViewCell).with(text: output)
                }
            }
        }

        return UITableViewCell()
    }

}

protocol InputChangedDelegate: class {
    
    func inputChanged(_ input: Input?)
    
}
