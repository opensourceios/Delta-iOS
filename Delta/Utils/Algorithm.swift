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
    var inputs: [String: Token]
    var actions: [Action]
    
    init(id: Int, name: String, actions: [Action]) {
        // Init values
        self.id = id
        self.name = name
        self.inputs = [String: Token]()
        self.actions = actions
        
        // Extract inputs from actions
        self.extractInputs()
    }
    
    func extractInputs() {
        // Clear inputs
        self.inputs = [String: Token]()
        
        // Iterate actions
        for action in actions {
            // Iterate inputs found in this action
            for input in action.extractInputs() {
                // Add it to inputs
                inputs[input.0] = input.1
            }
        }
    }
    
    func execute() -> Process {
        // Create a process with inputs
        let process = Process(inputs: inputs)
        
        // Iterate actions
        for action in actions {
            // Execute them
            action.execute(in: process)
        }
        
        // Return the process
        return process
    }
    
    func toString() -> String {
        return actions.map{ $0.toString() }.joined(separator: "\n")
    }
    
    func toEditorLines() -> [EditorLine] {
        return actions.flatMap{ $0.toEditorLines() }
    }
    
    func editorLinesCount() -> Int {
        return actions.map{ $0.editorLinesCount() }.reduce(0, +)
    }
    
    func insert(action: Action, at: Int) {
        
    }
    
    func update(line: EditorLine, at index: Int) {
        // Iterate actions
        var i = 0
        for action in actions {
            // Get size
            let size = action.editorLinesCount()
            
            // Check if index is in this action
            if i + size > index {
                // Delegate to action
                action.update(line: line, at: index - i)
                
                // Extract inputs again
                extractInputs()
                
                // Stop here
                return
            } else {
                // Continue
                i += size
            }
        }
    }
    
}
