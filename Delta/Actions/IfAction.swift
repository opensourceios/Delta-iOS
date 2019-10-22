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
        var lines = [EditorLine(format: "action_if".localized(), category: .structure, values: [condition.toString()])]
        
        for action in actions {
            lines.append(contentsOf: action.toEditorLines().map{ $0.incrementIndentation() })
        }
        
        lines.append(EditorLine(format: "", category: .add, indentation: 1))
        
        if let elseAction = elseAction {
            lines.append(contentsOf: elseAction.toEditorLines())
        }
        
        lines.append(EditorLine(format: "action_endif".localized(), category: .structure))
        
        return lines
    }
    
    func editorLinesCount() -> Int {
        var count = actions.map{ $0.editorLinesCount() }.reduce(0, +) + 3
        
        if let elseAction = elseAction {
            count += elseAction.editorLinesCount()
        }
        
        return count
    }
    
    func action(at index: Int) -> Action {
        if index != 0 && index < editorLinesCount()-2 {
            // Iterate actions
            var i = 1
            for action in actions {
                // Get size
                let size = action.editorLinesCount()
                
                // Check if index is in this action
                if i + size > index {
                    // Delegate to action
                    return action.action(at: index - i)
                } else {
                    // Continue
                    i += size
                }
            }
            
            // Check if button
            if index == i {
                return self
            }
            
            // Increment to skip add button
            i += 1
            
            // Delegate to else actions
            if let elseAction = elseAction {
                return elseAction.action(at: index - i)
            }
        }
        
        return self
    }
    
    func update(line: EditorLine) {
        if line.values.count == 1 {
            // Get "if condition"
            self.condition = TokenParser(line.values[0]).execute()
        }
    }
    
    func extractInputs() -> [(String, Token)] {
        return actions.flatMap{ $0.extractInputs() } + (elseAction?.extractInputs() ?? [])
    }
    
}
