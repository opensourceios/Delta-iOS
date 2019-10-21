//
//  IfAction.swift
//  Delta
//
//  Created by Nathan FALLET on 06/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class IfAction: Action {
    
    var condition: Token
    var actions: [Action]
    var elseActions: [Action]
    
    init(_ condition: Token, do actions: [Action], else elseActions: [Action] = []) {
        self.condition = condition
        self.actions = actions
        self.elseActions = elseActions
    }
    
    func execute(in process: Process) {
        // Get computed condition and check it
        if let condition = self.condition.compute(with: process.variables, format: false) as? Equation, condition.isTrue(with: process.variables) {
            // Execute actions
            for action in actions {
                action.execute(in: process)
            }
        } else {
            // Execute else actions
            for action in elseActions {
                action.execute(in: process)
            }
        }
    }
    
    func toString() -> String {
        var string = "if \"\(condition.toString())\" {"
        
        for action in actions {
            string += "\n\(action.toString().indentLines())"
        }
        
        if !elseActions.isEmpty {
            string += "\n} else {"
            for action in elseActions {
                string += "\n\(action.toString().indentLines())"
            }
        }
        
        string += "\n}"
        
        return string
    }
    
    func toEditorLines() -> [EditorLine] {
        var lines = [EditorLine(format: "action_if".localized(), values: [condition.toString()])]
        
        for action in actions {
            lines.append(contentsOf: action.toEditorLines().map{ $0.incrementIndentation() })
        }
        
        if !elseActions.isEmpty {
            lines.append(EditorLine(format: "action_else".localized()))
            for action in elseActions {
                lines.append(contentsOf: action.toEditorLines().map{ $0.incrementIndentation() })
            }
        }
        
        lines.append(EditorLine(format: "action_endif".localized()))
        
        return lines
    }
    
    func editorLinesCount() -> Int {
        return actions.map{ $0.editorLinesCount() }.reduce(0, +) + 2 + (!elseActions.isEmpty ? elseActions.map{ $0.editorLinesCount() }.reduce(0, +) + 1 : 0)
    }
    
    func update(line: EditorLine, at index: Int) {
        if index == 0 && line.values.count == 1 {
            // Get "if condition"
            self.condition = TokenParser(line.values[0]).execute()
        } else if index != 0 && index < editorLinesCount()-1 {
            // Iterate actions
            var i = 1
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
            
            // Iterate else actions
            i += 1
            for action in elseActions {
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
        }
    }
    
}
