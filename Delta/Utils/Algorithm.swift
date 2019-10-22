//
//  Algorithm.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class Algorithm {
    
    var id: Int?
    var name: String
    var inputs: [(String, Token)]
    var root: RootAction
    
    init(id: Int, name: String, root: RootAction) {
        // Init values
        self.id = id
        self.name = name
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
    
    func action(at index: Int) -> Action {
        return root.action(at: index)
    }
    
    func insert(action: Action, at index: Int) {
        if let block = self.action(at: index) as? ActionBlock {
            block.append(actions: [action])
        }
    }
    
    func update(line: EditorLine, at index: Int) {
        action(at: index).update(line: line)
    }
    
}
