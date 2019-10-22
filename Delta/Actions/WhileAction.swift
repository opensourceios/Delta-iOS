//
//  WhileAction.swift
//  Delta
//
//  Created by Nathan FALLET on 07/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class WhileAction: ActionBlock {
    
    var condition: Token
    var actions: [Action]
    
    init(_ condition: Token, do actions: [Action]) {
        self.condition = condition
        self.actions = actions
    }
    
    func append(actions: [Action]) {
        self.actions.append(contentsOf: actions)
    }
    
    func execute(in process: Process) {
        // Check if condition is true
        while (condition.compute(with: process.variables, format: false) as? Equation)?.isTrue(with: process.variables) ?? false {
            // Execute actions
            for action in actions {
                action.execute(in: process)
            }
        }
    }
    
    func toString() -> String {
        var string = "while \"\(condition.toString())\" {"
        
        for action in actions {
            string += "\n\(action.toString().indentLines())"
        }
        
        string += "\n}"
        
        return string
    }
    
    func toEditorLines() -> [EditorLine] {
        var lines = [EditorLine(format: "action_while".localized(), category: .structure, values: [condition.toString()])]
        
        for action in actions {
            lines.append(contentsOf: action.toEditorLines().map{ $0.incrementIndentation() })
        }
        
        lines.append(EditorLine(format: "", category: .add, indentation: 1))
        lines.append(EditorLine(format: "action_endif".localized(), category: .structure))
        
        return lines
    }
    
    func editorLinesCount() -> Int {
        return actions.map{ $0.editorLinesCount() }.reduce(0, +) + 3
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
        }
        
        return self
    }
    
    func update(line: EditorLine) {
        if line.values.count == 1 {
            // Get "while condition"
            self.condition = TokenParser(line.values[0]).execute()
        }
    }
    
    func extractInputs() -> [(String, Token)] {
        return actions.flatMap{ $0.extractInputs() }
    }
    
}
