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
    
    func isTrue(with inputs: [Input]) -> Bool {
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
    
    func compute(with inputs: [Input]) -> Token {
        let left = self.left.compute(with: inputs)
        let right = self.right.compute(with: inputs)
        
        return Equation(left: left, right: right, operation: operation)
    }
    
    func getSign() -> FloatingPointSign {
        return .plus
    }
    
    func changedSign() -> Bool {
        return false
    }
    
}
