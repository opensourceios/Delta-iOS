//
//  Product.swift
//  Delta
//
//  Created by Nathan FALLET on 09/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

struct Product: Token {
    
    var values: [Token]
    
    func toString() -> String {
        // To be optimized (for minus, paranthesis, ...)
        
        /*
         
         // Operation
         var op = true
         if operation == .multiplication {
             if bright {
                 // Don't add it
                 op = false
             } else if right as? Variable != nil {
                 // Don't add it
                 op = false
             } else if let right = right as? Expression {
                 if right.operation == .power && right.left as? Number == nil {
                     // Don't add it
                     op = false
                 }
                 if right.operation == .multiplication && right.left as? Variable != nil {
                     // Don't add it
                     op = false
                 }
             }
         }
         
         */
        
        return values.map {
            if $0.needBrackets(for: .multiplication) {
                return "(\($0.toString()))"
            } else {
                return $0.toString()
            }
        }.joined(separator: " * ")
    }
    
    func compute(with inputs: [String : Token]) -> Token {
        // Compute all values
        var values = self.values.map{ $0.compute(with: inputs) }.sorted{ $0.getMultiplicationPriority() > $1.getMultiplicationPriority() }
        
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
                    
                    // Multiply them
                    let product = value.apply(operation: .multiplication, right: otherValue, with: inputs)
                    
                    // If it is simpler than a product
                    if product as? Product == nil {
                        // Update values
                        value = product
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
            
            // Check for one (1x is x)
            if let number = value as? Number, number.value == 1 {
                // Remove one
                values.remove(at: index)
                index -= 1
            }
            
            // Check for zero (0x is 0)
            else if let number = value as? Number, number.value == 0 {
                // Return zero
                return number
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
        
        // Return the simplified product
        return Product(values: values)
    }
    
    func apply(operation: Operation, right: Token, with inputs: [String : Token]) -> Token {
        // Compute right
        let right = right.compute(with: inputs)
        
        // If addition
        if operation == .addition {
            // TODO: Check for common factor
            
            // Add token to sum
            return Sum(values: [self, right])
        }
        
        // If subtraction
        if operation == .subtraction {
            // Add token to sum
            return Sum(values: [self, right.opposite()]).compute(with: inputs)
        }
        
        // If product
        if operation == .multiplication {
            // Add token to product
            return Product(values: values + [right])
        }
        
        // If fraction
        if operation == .division {
            // Add token to fraction
            return Fraction(numerator: self, denominator: right)
        }
        
        // Power
        if operation == .power {
            return Product(values: values.map{ Power(token: $0, power: right) })
        }
        
        // Root
        if operation == .root {
            return Product(values: values.map{ Root(token: $0, power: right) })
        }
        
        // Unknown, return a calcul error
        return CalculError()
    }
    
    func needBrackets(for operation: Operation) -> Bool {
        return operation.getPrecedence() >= Operation.addition.getPrecedence()
    }
    
    func getMultiplicationPriority() -> Int {
        1
    }
    
    func opposite() -> Token {
        return Product(values: values + [Number(value: -1)])
    }
    
    func inverse() -> Token {
        return Fraction(numerator: Number(value: 1), denominator: self)
    }
    
    func getSign() -> FloatingPointSign {
        // To be done
        return .plus
    }
    
}
