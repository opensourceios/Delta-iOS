//
//  Operation.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

enum Operation: String {
    
    // Values
    case addition = "+", subtraction = "-", multiplication = "*", division = "/", modulo = "%", power = "^", root = "√", equals = "=", inequals = "!=", greaterThan = ">", lessThan = "<", greaterOrEquals = ">=", lessOrEquals = "<=", list = ",", vector = ";"
    
    // Get precedence
    func getPrecedence() -> Int {
        if self == .power {
            return 3
        }
        if self == .multiplication || self == .division || self == .modulo {
            return 2
        }
        return 1
    }
    
    // Join with two tokens
    func join(left: Token, right: Token) -> Token {
        // Check for equations
        if self == .equals || self == .inequals || self == .greaterThan || self == .lessThan || self == .greaterOrEquals || self == .lessOrEquals {
            return Equation(left: left, right: right, operation: self)
        }
        
        // Simple expression
        return left.apply(operation: self, right: right, with: [:], format: true)
    }
    
}
