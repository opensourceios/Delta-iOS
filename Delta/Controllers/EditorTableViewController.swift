//
//  EditorTableViewController.swift
//  Delta
//
//  Created by Nathan FALLET on 20/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import UIKit

class EditorTableViewController: UITableViewController, EditorLineChangedDelegate {
    
    let algorithm: Algorithm
    let completionHandler: (Algorithm) -> ()
    
    init(algorithm: Algorithm, completionHandler: @escaping (Algorithm) -> ()) {
        self.algorithm = algorithm.clone()
        self.completionHandler = completionHandler
        super.init(style: .grouped)
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cancel".localized(), style: .plain, target: self, action: #selector(close(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "save".localized(), style: .plain, target: self, action: #selector(save(_:)))
        
        // No separator
        tableView.separatorStyle = .none
        
        // Register cells
        tableView.register(EditorTableViewCell.self, forCellReuseIdentifier: "editorCell")
        tableView.register(EditorAddTableViewCell.self, forCellReuseIdentifier: "editorAddCell")
    }
    
    func editorLineChanged(_ line: EditorLine?, at index: Int) {
        // Get line
        if let line = line {
            // Update the line into algorithm
            algorithm.update(line: line, at: index)
        }
    }
    
    func editorLineAdded(_ action: Action, at index: Int) {
        // Add the line into algorithm
        algorithm.insert(action: action, at: index)
        
        // Insert new rows
        let count = action.editorLinesCount()
        tableView.beginUpdates()
        tableView.insertRows(at: (0 ..< count).map{ IndexPath(row: index + $0, section: 0) }, with: .automatic)
        tableView.endUpdates()
        
        // Refresh all buttons
        let lines = algorithm.toEditorLines()
        for i in 0 ..< lines.count {
            // Check if it is a button
            if lines[i].category == .add {
                // Get cell
                if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? EditorAddTableViewCell {
                    // Update index
                    cell.index = i
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return algorithm.editorLinesCount()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "instructions".localized()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get editor line
        let line = algorithm.toEditorLines()[indexPath.row]
        
        // Check if add
        if line.category == .add {
            // Return cell
            return (tableView.dequeueReusableCell(withIdentifier: "editorAddCell", for: indexPath) as! EditorAddTableViewCell).with(line: line, delegate: self, at: indexPath.row)
        }
        
        // Return cell
        return (tableView.dequeueReusableCell(withIdentifier: "editorCell", for: indexPath) as! EditorTableViewCell).with(line: line, delegate: self, at: indexPath.row)
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
        // Dismiss view controller
        dismiss(animated: true, completion: nil)
    }
    
    @objc func save(_ sender: UIBarButtonItem) {
        // Disable button while saving
        sender.isEnabled = false
        
        // Async call
        DispatchQueue.global(qos: .background).async {
            // Save algorithm to database
            let newAlgorithm = Database.current.updateAlgorithm(self.algorithm)
            
            // UI call
            DispatchQueue.main.async {
                // Call completion handler
                self.completionHandler(newAlgorithm)
                
                // Dismiss view controller
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

}

protocol EditorLineChangedDelegate: class {
    
    func editorLineChanged(_ line: EditorLine?, at index: Int)
    func editorLineAdded(_ action: Action, at index: Int)
    
}
