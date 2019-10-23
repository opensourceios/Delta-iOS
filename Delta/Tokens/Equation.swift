//
//  Equation.swift
//  Delta
//
//  Created by Nathan FALLET on 08/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

struct Equation: Token {
    
    var left: Token
    var right: Token
    var operation: Operation
    
    func isTrue(with inputs: [String: Token]) -> Bool {
        let left = self.left.compute(with: inputs, format: false)
        let right = self.right.compute(with: inputs, format: false)
        
        if let left = left.asDouble(), let right = right.asDouble() {
            if operation == .equals {
                return left == right
            } else if operation == .unequals {
                return left != right
            } else if operation == .greaterThan {
                return left > right
            } else if operation == .lessThan {
                return left < right
            } else if operation == .greaterOrEquals {
                return left >= right
            } else if operation == .lessOrEquals {
                return left <= right
            }
        }
        
        return false
    }
    
    func toString() -> String {
        return "\(left.toString()) \(operation.rawValue) \(right.toString())"
    }
    
    func compute(with inputs: [String: Token], format: Bool) -> Token {
        let left = self.left.compute(with: inputs, format: format)
        let right = self.right.compute(with: inputs, format: format)
        
        return Equation(left: left, right: right, operation: operation)
    }
    
    func apply(operation: Operation, right: Token, with inputs: [String: Token], format: Bool) -> Token {
        // Unknown, return a calcul error
        return CalculError()
    }
    
    func needBrackets(for operation: Operation) -> Bool {
        return false
    }
    
    func getMultiplicationPriority() -> Int {
        return 1
    }
    
    func opposite() -> Token {
        return Equation(left: left.opposite(), right: right.opposite(), operation: operation)
    }
    
    func inverse() -> Token {
        return Equation(left: left.inverse(), right: right.inverse(), operation: operation)
    }
    
    func asDouble() -> Double? {
        return nil
    }
    
    func getSign() -> FloatingPointSign {
        return .plus
    }
    
}
