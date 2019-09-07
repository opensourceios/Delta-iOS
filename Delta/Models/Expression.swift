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
        if let expr1 = left as? Expression, let expr2 = right as? Expression, expr1.operation.getPrecedence() == 1, expr2.operation.getPrecedence() == 1, operation.getPrecedence() == 2 {
            return "(\(left.toString())) \(operation.toString()) (\(right.toString()))".exponentize()
        }
        
        // Check for brackets on the left
        if let expr = left as? Expression, expr.operation.getPrecedence() == 1, operation.getPrecedence() == 2 {
            return "(\(left.toString())) \(operation.toString()) \(right.toString())".exponentize()
        }
        
        // Check for brackets on the right
        if let expr = right as? Expression, expr.operation.getPrecedence() == 1, operation.getPrecedence() == 2 {
            return "\(left.toString()) \(operation.toString()) (\(right.toString()))".exponentize()
        }
        
        // No brackets required
        return "\(left.toString()) \(operation.toString()) \(right.toString())".exponentize()
    }
    
    func compute(with inputs: [Input]) -> Token {
        // Compute expression terms
        let left = self.left.compute(with: inputs)
        let right = self.right.compute(with: inputs)
        
        // Check if any error
        if left as? SyntaxError != nil || right as? SyntaxError != nil {
            // Return it
            return SyntaxError()
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
            return left.applyToken(operation: operation, right: right)
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
                    return SyntaxError()
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
        
        // Can't join left and right, return it
        return Expression(left: left, right: right, operation: operation)
    }
    
}
