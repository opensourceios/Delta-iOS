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
    
}
