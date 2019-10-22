//
//  IfAction.swift
//  Delta
//
//  Created by Nathan FALLET on 06/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class IfAction: ActionBlock {
    
    var condition: Token
    var actions: [Action]
    var elseAction: ElseAction?
    
    init(_ condition: Token, do actions: [Action], else elseAction: ElseAction? = nil) {
        self.condition = condition
        self.actions = actions
        self.elseAction = elseAction
    }
    
    func append(actions: [Action]) {
        self.actions.append(contentsOf: actions)
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
            elseAction?.execute(in: process)
        }
    }
    
    func toString() -> String {
        var string = "if \"\(condition.toString())\" {"
        
        for action in actions {
            string += "\n\(action.toString().indentLines())"
        }
        
        string += "\n}"
        
        if let elseAction = elseAction {
            string += elseAction.toString()
        }
        
        return string
    }
    
    func toEditorLines() -> [EditorLine] {
        var lines = [EditorLine(format: "action_if".localized(), values: [condition.toString()])]
        
        for action in actions {
            lines.append(contentsOf: action.toEditorLines().map{ $0.incrementIndentation() })
        }
        
        if let elseAction = elseAction {
            lines.append(contentsOf: elseAction.toEditorLines())
        }
        
        lines.append(EditorLine(format: "action_endif".localized()))
        
        return lines
    }
    
    func editorLinesCount() -> Int {
        var count = actions.map{ $0.editorLinesCount() }.reduce(0, +) + 2
        
        if let elseAction = elseAction {
            count += elseAction.editorLinesCount()
        }
        
        return count
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
            
            // Delegate to else actions
            if let elseAction = elseAction {
                elseAction.update(line: line, at: index - i)
            }
        }
    }
    
}
