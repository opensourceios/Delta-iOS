//
//  ForAction.swift
//  Delta
//
//  Created by Nathan FALLET on 07/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class ForAction: ActionBlock {
    
    var identifier: String
    var token: Token
    var actions: [Action]
    
    init(_ identifier: String, in token: Token, do actions: [Action]) {
        self.identifier = identifier
        self.token = token
        self.actions = actions
    }
    
    func append(actions: [Action]) {
        self.actions.append(contentsOf: actions)
    }
    
    func execute(in process: Process) {
        // Get computed token
        let token = self.token.compute(with: process.variables, format: false)
        
        // Get list
        if let list = token as? List {
            // Iterate list
            for element in list.values {
                // Set value
                process.variables[identifier] = element
                
                // Execute actions
                for action in actions {
                    action.execute(in: process)
                }
            }
        }
        
        // Get interval
        // TODO
    }
    
    func toString() -> String {
        var string = "for \"\(identifier)\" in \"\(token.toString())\" {"
        
        for action in actions {
            string += "\n\(action.toString().indentLines())"
        }
        
        string += "\n}"
        
        return string
    }
    
    func toEditorLines() -> [EditorLine] {
        var lines = [EditorLine(format: "action_for".localized(), values: [identifier, token.toString()])]
        
        for action in actions {
            lines.append(contentsOf: action.toEditorLines().map{ $0.incrementIndentation() })
        }
        
        lines.append(EditorLine(format: "action_endif".localized()))
        
        return lines
    }
    
    func editorLinesCount() -> Int {
        return actions.map{ $0.editorLinesCount() }.reduce(0, +) + 2
    }
    
    func update(line: EditorLine, at index: Int) {
        if index == 0 && line.values.count == 2 {
            // Get "for identifier in token"
            self.identifier = line.values[0]
            self.token = TokenParser(line.values[1]).execute()
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
        }
    }
    
    func extractInputs() -> [(String, Token)] {
        return actions.flatMap{ $0.extractInputs() }
    }
    
}
