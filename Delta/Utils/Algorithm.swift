//
//  Algorithm.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class Algorithm {
    
    var name: String
    var inputs: [String: Token]
    var actions: [Action]
    
    init(name: String, inputs: [String: Token], actions: [Action]) {
        self.name = name
        self.inputs = inputs
        self.actions = actions
    }
    
    func execute() -> Process {
        let process = Process(inputs: inputs)
        
        for action in actions {
            action.execute(in: process)
        }
        
        return process
    }
    
    func toString() -> String {
        return actions.map{ $0.toString() }.joined(separator: "\n")
    }
    
    func toInputEditorLines() -> [EditorLine] {
        return inputs.sorted{ return $0.key < $1.key }.map{ EditorLine(format: "action_input".localized(), values: [$0, $1.toString()], type: .input) }
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
        if line.type == .action {
            // Iterate actions
            var i = 0
            for action in actions {
                // Get size
                let size = action.editorLinesCount()
                
                // Check if index is in this action
                if i + size > index {
                    // Delegate to action
                    action.update(line: line, at: index - i)
                    return
                } else {
                    // Continue
                    i += size
                }
            }
        } else if line.type == .input {
            // Iterate inputs
            
        }
    }
    
}
