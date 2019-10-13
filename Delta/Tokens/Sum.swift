//
//  Sum.swift
//  Delta
//
//  Created by Nathan FALLET on 09/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

struct Sum: Token {
    
    var values: [Token]
    
    func toString() -> String {
        // To be optimized (for minus)
        return values.map{ $0.toString() }.joined(separator: " + ")
    }
    
    func compute(with inputs: [String : Token]) -> Token {
        // Compute all values
        var values = self.values.map{ $0.compute(with: inputs) }
        
        // Some required vars
        var index = 0
        
        // Iterate values
        while index < values.count {
            // Get value
            var value = values[index]
            
            // Iterate to add it to another value
            var i = 0
            while i < values.count {
                // Check if it's not the same index
                if i != index {
                    // Get another value
                    let otherValue = values[i]
                    
                    // Sum them
                    let sum = value.apply(operation: .addition, right: otherValue, with: inputs)
                    
                    // If it is simpler than a sum
                    if sum as? Sum == nil {
                        // Update values
                        value = sum
                        values[index] = value
                        
                        // Remove otherValue
                        values.remove(at: i)
                        
                        // Update indexes
                        index -= index >= i ? 1 : 0
                        i -= 1
                    }
                }
                
                // Increment i
                i += 1
            }
            
            // Check for zero (0 + x is x)
            if let number = value as? Number, number.value == 0 {
                // Remove zero
                values.remove(at: index)
                index -= 1
            }
            
            // Increment index
            index += 1
        }
        
        // If only one value left
        if values.count == 1 {
            return values[0]
        }
        
        // If empty
        if values.isEmpty {
            return Number(value: 0)
        }
        
        // Return the simplified sum
        return Sum(values: values)
    }
    
    func apply(operation: Operation, right: Token, with inputs: [String : Token]) -> Token {
        // If addition
        if operation == .addition {
            // Add token to sum
            return Sum(values: values + [right])
        }
        
        // If product
        if operation == .multiplication {
            // Add token to product
            return Product(values: [self, right])
        }
        
        // If fraction
        if operation == .division {
            // Add token to fraction
            return Fraction(numerator: self, denominator: right)
        }
        
        // Power
        if operation == .power {
            return Power(token: self, power: right)
        }
        
        // Root
        if operation == .root {
            return Root(token: self, power: right)
        }
        
        // Unknown, return an exoression
        return Expression(left: self, right: right, operation: operation)
    }
    
    func needBrackets(for operation: Operation) -> Bool {
        return operation.getPrecedence() >= Operation.addition.getPrecedence()
    }
    
    func getMultiplicationPriority() -> Int {
        1
    }
    
    func opposite() -> Token {
        return Sum(values: values.map{ $0.opposite() })
    }
    
    func inverse() -> Token {
        return Fraction(numerator: Number(value: 1), denominator: self)
    }
    
    func getSign() -> FloatingPointSign {
        // To be done
        return .plus
    }
    
}
