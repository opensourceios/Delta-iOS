//
//  Algorithm.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class Algorithm {
    
    // Properties
    var local_id: Int64
    var remote_id: Int64?
    var owner: Bool
    var name: String
    var last_update: Date
    var icon: AlgorithmIcon
    var inputs: [(String, String)]
    var root: RootAction
    var status: APISyncStatus
    
    // Initializer
    
    init(local_id: Int64, remote_id: Int64?, owner: Bool, name: String, last_update: Date, icon: AlgorithmIcon, root: RootAction) {
        // Init values
        self.local_id = local_id
        self.remote_id = remote_id
        self.name = name
        self.owner = owner
        self.last_update = last_update
        self.icon = icon
        self.inputs = []
        self.root = root
        self.status = remote_id ?? 0 != 0 ? .synchronized : .local
        
        // Extract inputs from actions
        self.extractInputs()
    }
    
    // Inputs
    
    func extractInputs() {
        // Set inputs from root
        self.inputs = root.extractInputs()
    }
    
    // Execute
    
    func execute() -> Process {
        // Create a process with inputs
        let process = Process(inputs: inputs)
        
        // Execute root
        root.execute(in: process)
        
        // Return the process
        return process
    }
    
    // Export
    
    func toString() -> String {
        return root.toString()
    }
    
    // Actions editor lines
    
    func toEditorLines() -> [EditorLine] {
        return root.toEditorLines()
    }
    
    func editorLinesCount() -> Int {
        return root.editorLinesCount()
    }
    
    func action(at index: Int) -> (Action, Action, Int) {
        return root.action(at: index, parent: root, parentIndex: 0)
    }
    
    func insert(action: Action, at index: Int) -> Range<Int> {
        // Get where to add it
        let result = self.action(at: index)
        
        // Check if we have a block to add it
        if let block = result.1 as? ActionBlock {
            // Add it
            block.insert(action: action, at: result.2)
            
            // Return the range of new lines
            return index ..< index + action.editorLinesCount()
        }
        
        // Not added
        return 0 ..< 0
    }
    
    func update(line: EditorLine, at index: Int) {
        // Check settings
        if line.category == .settings {
            // Update settings
            updateSettings(at: index, with: line.values)
        } else {
            // Update actions
            action(at: index).0.update(line: line)
        }
    }
    
    func delete(at index: Int) -> Range<Int> {
        // Get where to delete it
        let result = self.action(at: index)
        
        // Check if we have a block to delete it
        if let block = result.1 as? ActionBlock {
            // Delete it
            block.delete(at: result.2)
            
            // Return the range of old lines
            return index ..< index + result.0.editorLinesCount()
        }
        
        // Not deleted
        return 0 ..< 0
    }
    
    func move(from fromIndex: Int, to toIndex: Int) -> (Range<Int>, Range<Int>) {
        // Check that index is different
        if fromIndex != toIndex {
            // Check if destination is not in the deleted range
            let sourceAction = self.action(at: fromIndex)
            let sourceRange = fromIndex ..< fromIndex + sourceAction.0.editorLinesCount()
            if !sourceRange.contains(toIndex) {
                // Delete the old line
                let range = delete(at: fromIndex)
                
                // Calculate new destination index
                var destination = toIndex < fromIndex ? toIndex : toIndex - range.count + 1
                
                // Get action at destination
                if destination > 0 {
                    let currentDestination = self.root.toEditorLines()[destination-1]
                    if currentDestination.category == .add {
                        // Remove one to skip add button
                        destination -= 1
                    }
                }
                
                // Add the new line
                let newRange = insert(action: sourceAction.0, at: destination)
                
                // Return modified ranges
                return (range, newRange)
            }
        }
        
        // Not moved
        return (0 ..< 0, 0 ..< 0)
    }
    
    // Settings editor lines
    
    func getSettings() -> [EditorLine] {
        return [EditorLine(format: "settings_name", category: .settings, values: [name], movable: false)]
    }
    
    func settingsCount() -> Int {
        return 1
    }
    
    func updateSettings(at index: Int, with values: [String]) {
        // Check index
        if index == 0 && values.count == 1 {
            // Index 0 - Algorithm's name
            self.name = values[0]
        }
    }
    
    // Clone algorithm to edit
    
    func clone() -> Algorithm {
        // Check if is owned
        if owner {
            // Create an instance with same informations
            return Algorithm(local_id: local_id, remote_id: remote_id, owner: true, name: name, last_update: last_update, icon: icon, root: root)
        } else {
            // Create a copy
            return Algorithm(local_id: 0, remote_id: nil, owner: true, name: "copy".localized().format(name), last_update: last_update, icon: icon, root: root)
        }
    }
    
    // Check for update from server
    
    func checkForUpdate(algorithmChanged: @escaping (Algorithm) -> Void) {
        // If there is a remote id
        if let remote_id = remote_id, remote_id != 0 {
            // Check for update
            status = .checkingforupdate
            algorithmChanged(self)
            APIRequest("GET", path: "/algorithm/checkforupdate.php").with(name: "id", value: remote_id).execute(APIAlgorithm.self) { data, status in
                // Check if data was downloaded
                if let data = data, let last_update = data.last_update?.toDate() {
                    // Compare last update date
                    let compare = self.last_update.compare(last_update)
                    if compare == .orderedAscending {
                        // Download algorithm
                        self.status = .downloading
                        algorithmChanged(self)
                        APIRequest("GET", path: "/algorithm/algorithm.php").with(name: "id", value: remote_id).execute(APIAlgorithm.self) { data, status in
                            // Check if data was downloaded
                            if let data = data {
                                // Save it to database
                                let updatedAlgorithm = data.saveToDatabase()
                                
                                // Replace it in lists
                                algorithmChanged(updatedAlgorithm)
                            } else {
                                // Update status
                                self.status = .failed
                                algorithmChanged(self)
                            }
                        }
                    } else if compare == .orderedDescending {
                        // Or upload it if it was modified
                        // TODO
                    } else {
                        // Algorithm is up to date
                        self.status = .synchronized
                        algorithmChanged(self)
                    }
                } else {
                    // Update status
                    self.status = .failed
                    algorithmChanged(self)
                }
            }
        }
    }
    
}
