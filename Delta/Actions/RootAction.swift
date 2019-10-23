//
//  RootAction.swift
//  Delta
//
//  Created by Nathan FALLET on 22/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class RootAction: ActionBlock {
    
    var actions: [Action]
    
    init(_ actions: [Action]) {
        self.actions = actions
    }
    
    func append(actions: [Action]) {
        self.actions.append(contentsOf: actions)
    }
    
    func execute(in process: Process) {
        // Execute actions
        for action in actions {
            action.execute(in: process)
        }
    }
    
    func toString() -> String {
        return actions.map{ $0.toString() }.joined(separator: "\n")
    }
    
    func toEditorLines() -> [EditorLine] {
        return actions.flatMap{ $0.toEditorLines() } + [EditorLine(format: "", category: .add)]
    }
    
    func editorLinesCount() -> Int {
        return actions.map{ $0.editorLinesCount() }.reduce(0, +) + 1
    }
    
    func action(at index: Int, parent: Action, parentIndex: Int) -> (Action, Action, Int) {
        if index < editorLinesCount()-1 {
            // Iterate actions
            var i = 0
            for action in actions {
                // Get size
                let size = action.editorLinesCount()
                
                // Check if index is in this action
                if i + size > index {
                    // Delegate to action
                    return action.action(at: index - i, parent: self, parentIndex: index)
                } else {
                    // Continue
                    i += size
                }
            }
        }
        
        return (self, parent, parentIndex)
    }
    
    func update(line: EditorLine) {
        // Nothing to update
    }
    
    func extractInputs() -> [(String, Token)] {
        return actions.flatMap{ $0.extractInputs() }
    }
    
}
