//
//  Operation.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

enum Operation {
    
    // Values
    case addition, subtraction, multiplication, division, power, equals, inequals, greaterThan, lessThan, greaterOrEquals, lessOrEquals, set
    
    // Convert to string
    func toString() -> String {
        switch self {
        case .addition:
            return "+"
        case .subtraction:
            return "-"
        case .multiplication:
            return "*"
        case .division:
            return "/"
        case .power:
            return "^"
        case .equals:
            return "="
        case .inequals:
            return "≠"
        case .greaterThan:
            return ">"
        case .lessThan:
            return "<"
        case .greaterOrEquals:
            return ">="
        case .lessOrEquals:
            return "<="
        case .set:
            return ";"
        }
    }
    
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
        if self == .addition || self == .subtraction || self == .multiplication || self == .division || self == .power {
            return Expression(left: left, right: right, operation: self)
        } else if self == .set {
            if let set = left as? Set {
                return Set(values: set.values + [right])
            } else {
                return Set(values: [left, right])
            }
        } else {
            return Equation(left: left, right: right, operation: self)
        }
    }
    
}
