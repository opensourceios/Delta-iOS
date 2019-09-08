//
//  Number.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

struct Number: Token {
    
    var value: Int
    
    func toString() -> String {
        return "\(value)"
    }
    
    func compute(with inputs: [Input]) -> Token {
        return self
    }
    
    func getSign() -> FloatingPointSign {
        return value >= 0 ? .plus : .minus
    }
    
    mutating func changedSign() -> Bool {
        self.value = -1 * value
        return true
    }
    
    func applyToken(operation: Operation, right: Token) -> Token {
        // Rigth is number
        if let right = right as? Number {
            // Apply a number
            return applyNumber(operation: operation, right: right)
        }
        
        // Right is an expression with two numbers
        if let right = right as? Expression, let uleft = right.left as? Number, let uright = right.right as? Number {
            // Multiply to this expression
            if operation != .division, operation != .power, operation.getPrecedence() >= right.operation.getPrecedence(), let newLeft = applyNumber(operation: operation, right: uleft) as? Number {
                return newLeft.applyNumber(operation: right.operation, right: uright)
            }
            
            // Add or subtract
            if (operation == .addition || operation == .subtraction) && right.operation == .division {
                return Expression(left: Expression(left: value.times(uright), right: uleft, operation: operation), right: uright, operation: .division)
            }
            
            // Power
            if operation == .power && right.operation == .division {
                let value = pow(Double(self.value), Double(uleft.value) / Double(uright.value))
                
                if value == .infinity || value.isNaN {
                    return CalculError()
                } else {
                    return Number(value: Int(value))
                }
            }
        }
        
        // Right is a set
        if let right = right as? Set {
            return right.multiply(by: self)
        }
        
        return Expression(left: self, right: right, operation: operation)
    }
    
    func applyNumber(operation: Operation, right: Number) -> Token {
        // Addition
        if operation == .addition {
            return Number(value: self.value + right.value)
        }
        
        // Subtraction
        if operation == .subtraction {
            return Number(value: self.value - right.value)
        }
        
        // Multiplication
        if operation == .multiplication {
            return Number(value: self.value * right.value)
        }
        
        // Division
        if operation == .division && self.value.isMultiple(of: right.value) {
            return Number(value: self.value / right.value)
        }
        
        // Power
        if operation == .power {
            return Number(value: Int(pow(Double(self.value), Double(right.value))))
        }
        
        return Expression(left: self, right: right, operation: operation)
    }
    
}
