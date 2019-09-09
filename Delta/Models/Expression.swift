//
//  Expression.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

struct Expression: Token {
    
    var left: Token
    var right: Token
    var operation: Operation
    
    func toString() -> String {
        // Check if there is a variable
        if right as? Variable != nil, operation == .multiplication {
            return "\(left.toString())\(right.toString())"
        }
        
        // Check for brackets on both sides
        if let expr1 = left as? Expression, let expr2 = right as? Expression, operation.getPrecedence() > expr1.operation.getPrecedence(), operation.getPrecedence() > expr2.operation.getPrecedence() {
            return "(\(left.toString())) \(operation.toString()) (\(right.toString()))".exponentize()
        }
        
        // Check for brackets on the left
        if let expr = left as? Expression, operation.getPrecedence() > expr.operation.getPrecedence() {
            return "(\(left.toString())) \(operation.toString()) \(right.toString())".exponentize()
        }
        
        // Check for brackets on the right
        if let expr = right as? Expression, operation.getPrecedence() > expr.operation.getPrecedence() {
            return "\(left.toString()) \(operation.toString()) (\(right.toString()))".exponentize()
        }
        
        // No brackets required
        return "\(left.toString()) \(operation.toString()) \(right.toString())".exponentize()
    }
    
    func compute(with inputs: [Input]) -> Token {
        // Compute expression terms
        let left = self.left.compute(with: inputs)
        var right = self.right.compute(with: inputs)
        
        // Check if any error
        if left as? SyntaxError != nil || right as? SyntaxError != nil {
            // Return it
            return SyntaxError()
        }
        
        // Right is negative and sign can be changed
        if right.getSign() == .minus && (operation == .addition || operation == .subtraction) && right.changedSign() {
            return Expression(left: left, right: right, operation: operation == .addition ? .subtraction : .addition).compute(with: inputs)
        }
        
        // Check if left is a number
        if let left = left as? Number {
            // If left is 1
            if left.value == 1 && operation == .multiplication {
                // It's 1 time right, return right
                return right
            }
            
            // If left is 0
            if left.value == 0 {
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
                    return Expression(left: Number(value: -1), right: right, operation: .multiplication).compute(with: inputs)
                }
            }
            
            // Apply right to left
            return left.apply(operation: operation, right: right, with: inputs)
        }
        
        // Check if right is a number
        if let right = right as? Number {
            // If right is 1
            if right.value == 1 && (operation == .multiplication || operation == .division || operation == .power) {
                // It's 1 time left, return left
                return left
            }
            
            // If right is 0
            if right.value == 0 {
                // x * 0 is 0
                if operation == .multiplication {
                    return Number(value: 0)
                }
                // x / 0 is error
                if operation == .division {
                    return CalculError()
                }
                // x ^ 0 is 1
                if operation == .power {
                    return Number(value: 1)
                }
                // x + 0 or x - 0 is x
                if operation == .addition || operation == .subtraction {
                    return left
                }
            }
        }
        
        // If left is a set, right too and multiplication
        if let left = left as? Vector, let right = right as? Vector, operation == .multiplication {
            return left.multiply(by: right)
        }
        
        // Can't join left and right, return it
        return Expression(left: left, right: right, operation: operation)
    }
    
    func apply(operation: Operation, right: Token, with inputs: [Input]) -> Token {
        // Right is a number
        if let right = right as? Number {
            
        }
        
        return Expression(left: self, right: right, operation: operation)
    }
    
    func getSign() -> FloatingPointSign {
        if operation == .addition {
            if left.getSign() == .plus && right.getSign() == .plus {
                return .plus
            }
        } else if operation == .subtraction {
            
        } else if operation == .multiplication || operation == .division {
            if (left.getSign() == .plus && right.getSign() == .plus) || (left.getSign() == .minus && right.getSign() == .minus) {
                return .plus
            } else {
                return .minus
            }
        } else if operation == .power {
            if left.getSign() == .plus {
                return .plus
            } else if left.getSign() == .minus, let right = right as? Number, right.value % 2 == 0 {
                return .plus
            } else {
                return .minus
            }
        }
        
        return .plus
    }
    
    mutating func changedSign() -> Bool {
        if operation == .multiplication || operation == .division {
            if left.changedSign() {
                return true
            } else if right.changedSign() {
                return true
            }
        }
        
        return false
    }
    
    func plus(_ right: String) -> Expression {
        return Expression(left: self, right: Variable(name: right), operation: .addition)
    }
    
    func plus(_ right: Token) -> Expression {
        return Expression(left: self, right: right, operation: .addition)
    }
    
    func minus(_ right: Token) -> Expression {
        return Expression(left: self, right: right, operation: .subtraction)
    }
    
    func times(_ right: String) -> Expression {
        return Expression(left: self, right: Variable(name: right), operation: .multiplication)
    }
    
    func times(_ right: Token) -> Expression {
        return Expression(left: self, right: right, operation: .multiplication)
    }
    
    func divides(_ right: Token) -> Expression {
        return Expression(left: self, right: right, operation: .division)
    }
    
    func power(_ right: Int) -> Expression {
        return Expression(left: self, right: Number(value: right), operation: .power)
    }
    
}
