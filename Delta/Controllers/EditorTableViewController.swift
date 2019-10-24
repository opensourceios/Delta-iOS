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
        let range = algorithm.insert(action: action, at: index)
        
        // Insert new rows
        tableView.beginUpdates()
        tableView.insertRows(at: range.map{ IndexPath(row: $0, section: 1) }, with: .automatic)
        tableView.endUpdates()
        
        // Refresh lines
        refreshLines()
    }
    
    func editorLineDeleted(_ line: EditorLine?, at index: Int) {
        // Get line
        if let line = line {
            // Delete the line into algorithm
            let range = algorithm.delete(line: line, at: index)
            
            // Delete old rows
            tableView.beginUpdates()
            tableView.deleteRows(at: range.map{ IndexPath(row: $0, section: 1) }, with: .automatic)
            tableView.endUpdates()
            
            // Refresh lines
            refreshLines()
        }
    }
    
    func refreshLines() {
        // Refresh lines
        let lines = algorithm.toEditorLines()
        for i in 0 ..< lines.count {
            // Get cell (classic line)
            if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 1)) as? EditorTableViewCell {
                // Update index
                cell.index = i
            }
            
            // Get cell (add)
            if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 1)) as? EditorAddTableViewCell {
                // Update index
                cell.index = i
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? algorithm.settingsCount() : algorithm.editorLinesCount()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "settings".localized() : "instructions".localized()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get editor line
        let line = indexPath.section == 0 ? algorithm.getSettings()[indexPath.row] : algorithm.toEditorLines()[indexPath.row]
        
        // Check if add
        if line.category == .add {
            // Return cell
            return (tableView.dequeueReusableCell(withIdentifier: "editorAddCell", for: indexPath) as! EditorAddTableViewCell).with(line: line, delegate: self, at: indexPath.row)
        }
        
        // Return cell
        return (tableView.dequeueReusableCell(withIdentifier: "editorCell", for: indexPath) as! EditorTableViewCell).with(line: line, delegate: self, at: indexPath.row)
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
    func editorLineDeleted(_ line: EditorLine?, at index: Int)
    
}
