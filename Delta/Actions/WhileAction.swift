//
//  WhileAction.swift
//  Delta
//
//  Created by Nathan FALLET on 07/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class WhileAction: Action {
    
    var condition: Equation
    var actions: [Action]
    
    init(_ condition: Equation, do actions: [Action]) {
        self.condition = condition
        self.actions = actions
    }
    
    func execute(in process: Process) {
        // Check if condition is true
        while condition.isTrue(with: process.variables) {
            // Execute actions
            for action in actions {
                action.execute(in: process)
            }
        }
    }
    
}
