//
//  Algorithm.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class Algorithm {
    
    var local_id: Int64
    var remote_id: Int64?
    var owner: Bool
    var name: String
    var last_update: Date
    var inputs: [(String, Token)]
    var root: RootAction
    
    init(local_id: Int64, remote_id: Int64?, owner: Bool, name: String, last_update: Date, root: RootAction) {
        // Init values
        self.local_id = local_id
        self.remote_id = remote_id
        self.name = name
        self.owner = owner
        self.last_update = last_update
        self.inputs = []
        self.root = root
        
        // Extract inputs from actions
        self.extractInputs()
    }
    
    func extractInputs() {
        // Clear inputs
        self.inputs = []
        
        // Iterate inputs in root
        for input in root.extractInputs() {
            // Add it to inputs
            inputs.append(input)
        }
    }
    
    func execute() -> Process {
        // Create a process with inputs
        let process = Process(inputs: inputs)
        
        // Execute root
        root.execute(in: process)
        
        // Return the process
        return process
    }
    
    func toString() -> String {
        return root.toString()
    }
    
    func toEditorLines() -> [EditorLine] {
        return root.toEditorLines()
    }
    
    func editorLinesCount() -> Int {
        return root.editorLinesCount()
    }
    
    func action(at index: Int) -> (Action, Action, Int) {
        return root.action(at: index, parent: root, parentIndex: 0)
    }
    
    func insert(action: Action, at index: Int) {
        let result = self.action(at: index)
        if let block = result.1 as? ActionBlock {
            block.append(actions: [action])
        }
    }
    
    func update(line: EditorLine, at index: Int) {
        action(at: index).0.update(line: line)
    }
    
    func clone() -> Algorithm {
        // Check if is owned
        if owner {
            // Create an instance with same informations
            return Algorithm(local_id: local_id, remote_id: remote_id, owner: owner, name: name, last_update: last_update, root: root)
        } else {
            // Create a copy
            return Algorithm(local_id: 0, remote_id: nil, owner: true, name: "copy".localized().format(name), last_update: last_update, root: root)
        }
    }
    
}
