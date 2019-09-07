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
    
    func applyToken(operation: Operation, right: Token) -> Token {
        // Rigth is number
        if let right = right as? Number {
            // Apply a number
            return applyNumber(operation: operation, right: right)
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
            return Number(value: self.value ^ right.value)
        }
        
        return Expression(left: self, right: right, operation: operation)
    }
    
}
