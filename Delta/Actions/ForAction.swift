//
//  ForAction.swift
//  Delta
//
//  Created by Nathan FALLET on 07/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class ForAction: Action {
    
    var identifier: String
    var token: Token
    var actions: [Action]
    
    init(_ identifier: String, in token: Token, do actions: [Action]) {
        self.identifier = identifier
        self.token = token
        self.actions = actions
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
        var string = "for \(identifier) in \(token.toString()) {"
        
        for action in actions {
            string += "\n\(action.toString())"
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
    
}
