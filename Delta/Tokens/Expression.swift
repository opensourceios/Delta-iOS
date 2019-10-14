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
    
    func shouldInvert() -> Bool {
        return operation == .multiplication && self.right.getMultiplicationPriority() > self.left.getMultiplicationPriority()
    }
    
    func toString() -> String {
        // Definition
        let left = shouldInvert() ? self.right : self.left
        let right = shouldInvert() ? self.left : self.right
        
        let bleft = left.needBrackets(for: operation)
        let bright = right.needBrackets(for: operation)
        
        var result = ""
        
        // Brackets on the left
        if bleft {
            result += "(\(left.toString()))"
        } else {
            result += "\(left.toString())"
        }
        
        // Operation
        result += " \(operation.toString()) "
        
        // Brackets on the right
        if bright {
            result += "(\(right.toString()))"
        } else {
            result += "\(right.toString())"
        }
        
        // Return result
        return result
    }
    
    func compute(with inputs: [String: Token]) -> Token {
        // Compute expression terms
        let left = shouldInvert() ? self.right.compute(with: inputs) : self.left.compute(with: inputs)
        let right = shouldInvert() ? self.left.compute(with: inputs) : self.right.compute(with: inputs)
        
        // Check if any error
        if left as? SyntaxError != nil || right as? SyntaxError != nil {
            // Return it
            return SyntaxError()
        }
        
        // Can't join left and right, return it
        return left.apply(operation: operation, right: right, with: inputs)
    }
    
    func apply(operation: Operation, right: Token, with inputs: [String: Token]) -> Token {
        // Compute right
        let right = right.compute(with: inputs)
        
        return Expression(left: self, right: right, operation: operation)
    }
    
    func needBrackets(for operation: Operation) -> Bool {
        return operation.getPrecedence() >= self.operation.getPrecedence()
    }
    
    func getMultiplicationPriority() -> Int {
        return 1
    }
    
    func opposite() -> Token {
        return Product(values: [self, Number(value: -1)])
    }
    
    func inverse() -> Token {
        return Fraction(numerator: Number(value: 1), denominator: self)
    }
    
    func getSign() -> FloatingPointSign {
        return .plus
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
    
    func sqrt() -> Expression {
        return Expression(left: self, right: Expression(left: Number(value: 1), right: Number(value: 2), operation: .division), operation: .power)
    }
    
}
