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
            return "(\(left.toString())) \(operation.toString()) (\(right.toString()))"
        }
        
        // Check for brackets on the left
        if let expr = left as? Expression, expr.operation.getPrecedence() == 1, operation.getPrecedence() == 2 {
            return "(\(left.toString())) \(operation.toString()) \(right.toString())"
        }
        
        // Check for brackets on the right
        if let expr = right as? Expression, expr.operation.getPrecedence() == 1, operation.getPrecedence() == 2 {
            return "\(left.toString()) \(operation.toString()) (\(right.toString()))"
        }
        
        // No brackets required
        return "\(left.toString()) \(operation.toString()) \(right.toString())"
    }
    
    func compute(with inputs: [Input]) -> Token {
        // Compute expression terms
        let left = self.left.compute(with: inputs)
        let right = self.right.compute(with: inputs)
        
        // Check if left is a number
        if let left = left as? Number {
            // Apply right to left
            return left.applyToken(operation: operation, right: right)
        }
        
        return self
    }
    
}
