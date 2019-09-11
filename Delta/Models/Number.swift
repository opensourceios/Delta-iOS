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
    
    func apply(operation: Operation, right: Token, with inputs: [Input]) -> Token {
        // Compute right
        let right = right.compute(with: inputs)
        
        // If value is 1
        if value == 1 && operation == .multiplication {
            // It's 1 time right, return right
            return right
        }
        
        // If value is 0
        if value == 0 {
            // 0 * x or 0 / x is 0
            if operation == .multiplication || operation == .division {
                return Number(value: 0)
            }
            // 0 + x is x
            if operation == .addition {
                return right
            }
            // 0 - x is -x
            if operation == .subtraction {
                return Number(value: -1).apply(operation: .multiplication, right: right, with: inputs)
            }
        }
        
        // Rigth is number
        if let right = right as? Number {
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
            if operation == .division {
                // Multiple so division is an integer
                if self.value.isMultiple(of: right.value) {
                    return Number(value: self.value / right.value)
                }
                
                // Get the greatest common divisor
                let gcd = self.value.greatestCommonDivisor(with: right.value)
                
                // If it's greater than one
                if gcd > 1 {
                    let numerator = self.value / gcd
                    let denominator = right.value / gcd
                    
                    // Return simplified fraction
                    return Expression(left: Number(value: numerator), right: Number(value: denominator), operation: operation)
                }
            }
            
            // Power
            if operation == .power {
                return Number(value: Int(pow(Double(self.value), Double(right.value))))
            }
        }
        
        // Right is an expression
        if let right = right as? Expression {
            // Addition and multiplication
            if operation == .addition || operation == .multiplication {
                // It's permutative
                return right.apply(operation: operation, right: self, with: inputs)
            }
            
            // Subtraction
            if operation == .subtraction {
                // Multiply expression by -1 and add self
                return apply(operation: .addition, right: Number(value: -1).apply(operation: .multiplication, right: right, with: inputs), with: inputs)
            }
            
            // Division
            if operation == .division {
                // If expression is a fraction
                if right.operation == .division {
                    // Multiply by its inverse
                    return apply(operation: .multiplication, right: right.right.apply(operation: .division, right: right.left, with: inputs), with: inputs)
                }
            }
            
            // Power
            if operation == .power {
                if right.operation == .division, let uleft = right.left as? Number, let uright = right.right as? Number {
                    let value = pow(Double(self.value), Double(uleft.value) / Double(uright.value))
                    
                    if value == .infinity || value.isNaN {
                        return CalculError()
                    } else if value == floor(value) {
                        return Number(value: Int(value))
                    }
                }
            }
        }
        
        // Right is a vector
        if let right = right as? Vector {
            // Addition, subtraction, division or power
            if operation == .addition || operation == .subtraction || operation == .division || operation == .power {
                // You can add numbers and vectors
                return CalculError()
            }
            
            // Multiplication
            if operation == .multiplication {
                return right.apply(operation: operation, right: self, with: inputs)
            }
        }
        
        return Expression(left: self, right: right, operation: operation)
    }
    
    func needBrackets(for operation: Operation) -> Bool {
        return false
    }
    
    func getMultiplicationPriority() -> Int {
        return 3
    }
    
    func getSign() -> FloatingPointSign {
        return value >= 0 ? .plus : .minus
    }
    
    mutating func changedSign() -> Bool {
        self.value = -1 * value
        return true
    }
    
}
