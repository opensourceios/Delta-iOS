//
//  IfAction.swift
//  Delta
//
//  Created by Nathan FALLET on 06/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class IfAction: Action {
    
    var condition: Equation
    var actions: [Action]
    var elseActions: [Action]
    
    init(_ condition: Equation, do actions: [Action], else elseActions: [Action] = []) {
        self.condition = condition
        self.actions = actions
        self.elseActions = elseActions
    }
    
    func execute(in process: Process) {
        // Check if condition is true
        if condition.isTrue(with: process.variables) {
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
