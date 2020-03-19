//
//  AlgorithmTableViewController.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import UIKit

class AlgorithmTableViewController: UITableViewController, AlgorithmSelectionDelegate, InputChangedDelegate {
    
    weak var delegate: AlgorithmsChangedDelegate?
    var algorithm: Algorithm?
    var currentOutputs = [Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cells
        tableView.register(InputTableViewCell.self, forCellReuseIdentifier: "inputCell")
        tableView.register(OutputTableViewCell.self, forCellReuseIdentifier: "outputCell")
        
        // Add edit/view button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "edit".localized(), style: .plain, target: self, action: #selector(showEditor(_:)))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func selectAlgorithm(_ algorithm: Algorithm?) {
        self.algorithm = algorithm
        
        // Update navigation bar
        navigationItem.title = algorithm?.name
        navigationItem.rightBarButtonItem?.isEnabled = algorithm != nil
        
        // Deselect active fields
        for cell in tableView.visibleCells {
            if let inputCell = cell as? InputTableViewCell {
                inputCell.endEditing(true)
            }
        }
        
        // Update inputs
        algorithm?.extractInputs()
        tableView.reloadData()
        
        // Update result shown on screen
        updateResult()
    }
    
    func inputChanged(_ input: (String, String)?) {
        // Get vars
        if let algorithm = algorithm, let input = input {
            // Update the input
            for i in 0 ..< algorithm.inputs.count {
                // Check key
                if algorithm.inputs[i].0 == input.0 {
                    // Set value
                    algorithm.inputs[i].1 = input.1
                }
            }
            
            // Update result shown on screen
            updateResult()
        }
    }
    
    func updateResult() {
        if let algorithm = algorithm {
            // Clear current outputs
            currentOutputs = []
            tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
            
            // Execute algorithm
            algorithm.execute() { process in
                // Get outputs
                self.currentOutputs = process.outputs
                
                // Refresh the output section
                DispatchQueue.main.async {
                    self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
                }
            }
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
                let input = algorithm.inputs[indexPath.row]
                
                // Create the cell
                return (tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as! InputTableViewCell).with(input: input, delegate: self)
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
    
    // Editor
    
    @objc func showEditor(_ sender: UIBarButtonItem) {
        if let algorithm = algorithm {
            // Create an editor
            let editor = EditorTableViewController(algorithm: Database.current.getAlgorithm(id_local: algorithm.local_id)) { newAlgorithm in
                // Update with new algorithm
                self.selectAlgorithm(newAlgorithm)
                
                // Update home view controller list
                self.delegate?.algorithmsChanged()
            }
            
            // Create the navigation controller
            let navigationController = UINavigationController(rootViewController: editor)
            navigationController.modalPresentationStyle = .fullScreen
            
            // Show it
            present(navigationController, animated: true, completion: nil)
        }
    }

}

protocol InputChangedDelegate: class {
    
    func inputChanged(_ input: (String, String)?)
    
}

protocol AlgorithmsChangedDelegate: class {
    
    func algorithmsChanged()
    
}
