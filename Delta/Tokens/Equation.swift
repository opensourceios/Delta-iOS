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
        let left = self.left.compute(with: inputs)
        let right = self.right.compute(with: inputs)
        
        if let left = left as? Number, let right = right as? Number {
            if operation == .equals {
                return left.value == right.value
            } else if operation == .inequals {
                return left.value != right.value
            } else if operation == .greaterThan {
                return left.value > right.value
            } else if operation == .lessThan {
                return left.value < right.value
            } else if operation == .greaterOrEquals {
                return left.value >= right.value
            } else if operation == .lessOrEquals {
                return left.value <= right.value
            }
        }
        
        return false
    }
    
    func toString() -> String {
        return "\(left.toString()) \(operation.toString()) \(right.toString())"
    }
    
    func compute(with inputs: [String: Token]) -> Token {
        let left = self.left.compute(with: inputs)
        let right = self.right.compute(with: inputs)
        
        return Equation(left: left, right: right, operation: operation)
    }
    
    func apply(operation: Operation, right: Token, with inputs: [String: Token]) -> Token {
        return Expression(left: self, right: right, operation: operation)
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
    
    func getSign() -> FloatingPointSign {
        return .plus
    }
    
}
