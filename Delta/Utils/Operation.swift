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
    case addition, subtraction, multiplication, division, power, equals, inequals, greaterThan, lessThan, greaterOrEquals, lessOrEquals, list, vector
    
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
        case .list:
            return ","
        case .vector:
            return ","
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
        // Check operation
        if self == .addition {
            // Addition
            if let sum = left as? Sum {
                return Sum(values: sum.values + [right])
            } else if let sum = right as? Sum {
                return Sum(values: sum.values + [left])
            } else {
                return Sum(values: [left, right])
            }
        } else if self == .multiplication {
            // Product
            if let product = left as? Product {
                return Product(values: product.values + [right])
            } else if let product = right as? Product {
                return Product(values: product.values + [left])
            } else {
                return Product(values: [left, right])
            }
        } else if self == .subtraction || self == .division || self == .power {
            // Basic operation
            return Expression(left: left, right: right, operation: self)
        } else if self == .list {
            // List
            if let set = left as? List {
                return List(values: set.values + [right])
            } else if let set = right as? List {
                return List(values: set.values + [left])
            } else {
                return List(values: [left, right])
            }
        } else if self == .vector {
            // Vector
            if let set = left as? Vector {
                return Vector(values: set.values + [right])
            } else if let set = right as? Vector {
                return Vector(values: set.values + [left])
            } else {
                return Vector(values: [left, right])
            }
        } else {
            // Equation
            return Equation(left: left, right: right, operation: self)
        }
    }
    
}
