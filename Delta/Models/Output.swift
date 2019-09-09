//
//  Output.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class Output {
    
    var name: String
    var expression: Token
    var conditions: [Equation]
    
    init(name: String, expression: Token, conditions: [Equation] = []) {
        self.name = name
        self.expression = expression
        self.conditions = conditions
    }
    
    func checkConditions(with inputs: [Input]) -> Bool {
        // Iterate all conditions
        for equation in conditions {
            // If the equation is false
            if !equation.isTrue(with: inputs) {
                // Condition are not respected
                return false
            }
        }
        
        // All conditions are respected
        return true
    }
    
    func toString(with inputs: [Input]) -> String {
        return "\(name) \(expression.compute(with: inputs).toString().exponentize())"
    }
    
}
