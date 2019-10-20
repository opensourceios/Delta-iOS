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
        var string = "if \(condition.toString()) {"
        
        for action in actions {
            string += "\n\(action.toString())"
        }
        
        if !elseActions.isEmpty {
            string += "\n} else {"
            for action in elseActions {
                string += "\n\(action.toString())"
            }
        }
        
        string += "\n}"
        
        return string
    }
    
    func toLocalizedStrings() -> [String] {
        var strings = ["action_if".localized().format(condition.toString())]
        
        for action in actions {
            strings.append(contentsOf: action.toLocalizedStrings())
        }
        
        if !elseActions.isEmpty {
            strings.append("action_else".localized())
            for action in elseActions {
                strings.append(contentsOf: action.toLocalizedStrings())
            }
        }
        
        strings.append("action_endif".localized())
        
        return strings
    }
    
}
