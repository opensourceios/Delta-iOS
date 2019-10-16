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
    
}
