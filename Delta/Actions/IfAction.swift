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
        if let condition = self.condition.compute(with: process.variables) as? Equation, condition.isTrue(with: process.variables) {
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
    
}
