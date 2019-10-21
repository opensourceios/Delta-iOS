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
    
    init(algorithm: Algorithm) {
        self.algorithm = algorithm
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "close".localized(), style: .plain, target: self, action: #selector(close(_:)))
        
        // No separator
        tableView.separatorStyle = .none
        
        // Register cells
        tableView.register(EditorTableViewCell.self, forCellReuseIdentifier: "editorCell")
    }
    
    func editorLineChanged(_ line: EditorLine?, at index: Int) {
        // Get vars
        if let line = line {
            // Update the line in algorithm
            algorithm.update(line: line, at: index)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? algorithm.toInputEditorLines().count : algorithm.editorLinesCount()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "inputs".localized() : "instructions".localized()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // Get input
            let line = algorithm.toInputEditorLines()[indexPath.row]
            
            // Return cell
            return (tableView.dequeueReusableCell(withIdentifier: "editorCell", for: indexPath) as! EditorTableViewCell).with(line: line, delegate: self, at: indexPath.row)
        } else {
            // Get editor line
            let line = algorithm.toEditorLines()[indexPath.row]
            
            // Return cell
            return (tableView.dequeueReusableCell(withIdentifier: "editorCell", for: indexPath) as! EditorTableViewCell).with(line: line, delegate: self, at: indexPath.row)
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

protocol EditorLineChangedDelegate: class {
    
    func editorLineChanged(_ line: EditorLine?, at index: Int)
    
}
