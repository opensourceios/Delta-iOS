//
//  WhileAction.swift
//  Delta
//
//  Created by Nathan FALLET on 07/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class WhileAction: Action {
    
    var condition: Token
    var actions: [Action]
    
    init(_ condition: Token, do actions: [Action]) {
        self.condition = condition
        self.actions = actions
    }
    
    func execute(in process: Process) {
        // Get computed condition
        if let condition = self.condition.compute(with: process.variables, format: false) as? Equation {
            // Check if condition is true
            while condition.isTrue(with: process.variables) {
                // Execute actions
                for action in actions {
                    action.execute(in: process)
                }
            }
        }
    }
    
    func toString() -> String {
        var string = "while \(condition.toString()) {"
        
        for action in actions {
            string += "\n\(action.toString())"
        }
        
        string += "\n}"
        
        return string
    }
    
    func toLocalizedStrings() -> [String] {
        var strings = ["action_while".localized().format(condition.toString())]
        
        for action in actions {
            strings.append(contentsOf: action.toLocalizedStrings())
        }
        
        strings.append("action_endif".localized())
        
        return strings
    }
    
}
