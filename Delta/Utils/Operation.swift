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
    case addition = "+", subtraction = "-", multiplication = "*", division = "/", power = "^", root = "√", equals = "=", inequals = "!=", greaterThan = ">", lessThan = "<", greaterOrEquals = ">=", lessOrEquals = "<=", list = ",", vector = ";"
    
    // Get precedence
    func getPrecedence() -> Int {
        if self == .power {
            return 3
        }
        if self == .multiplication || self == .division {
            return 2
        }
        return 1
    }
    
    // Join with two tokens
    func join(left: Token, right: Token) -> Token {
        left.apply(operation: self, right: right, with: [:], format: true)
    }
    
}
