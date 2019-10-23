//
//  ElseAction.swift
//  Delta
//
//  Created by Nathan FALLET on 21/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class ElseAction: ActionBlock {
    
    var actions: [Action]
    
    init(do actions: [Action]) {
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
        var string = " else {"
        
        for action in actions {
            string += "\n\(action.toString().indentLines())"
        }
        
        string += "\n}"
        
        return string
    }
    
    func toEditorLines() -> [EditorLine] {
        var lines = [EditorLine(format: "action_else".localized(), category: .structure)]
        
        for action in actions {
            lines.append(contentsOf: action.toEditorLines().map{ $0.incrementIndentation() })
        }
        
        lines.append(EditorLine(format: "", category: .add, indentation: 1))
        
        return lines
    }
    
    func editorLinesCount() -> Int {
        return actions.map{ $0.editorLinesCount() }.reduce(0, +) + 2
    }
    
    func action(at index: Int, parent: Action, parentIndex: Int) -> (Action, Action, Int) {
        if index != 0 && index < editorLinesCount()-1 {
            // Iterate actions
            var i = 1
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
        
        return (self, index == 0 ? parent : self, parentIndex)
    }
    
    func update(line: EditorLine) {
        // Nothing to update
    }
    
    func extractInputs() -> [(String, Token)] {
        return actions.flatMap{ $0.extractInputs() }
    }
    
}
