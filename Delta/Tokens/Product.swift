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
        var string = ""
        
        for value in values.sorted(by: { $0.getMultiplicationPriority() > $1.getMultiplicationPriority() }) {
            // Initialization
            let brackets = value.needBrackets(for: .multiplication)
            var asString = value.toString()
            var op = false
            
            // Check if not empty
            if !string.isEmpty {
                op = true
            }
            
            // Check if we need to keep operator
            if brackets {
                // No operator if we already have brackets
                op = false
            } else if value as? Variable != nil {
                // No operators for variables
                op = false
            } else if let power = value as? Power, power.token as? Number == nil {
                // No operator if we have power of not a number
                op = false
            } else if value as? Root != nil {
                // No operators for roots
                op = false
            }
            
            // Check for -1 and 1
            if let number = value as? Number, (number.value == -1 || number.value == 1) {
                // Remove the 1
                asString = asString[0 ..< asString.count-1]
            }
            
            // Add operator if required
            if op {
                string += " * "
            }
            
            // Check for brackets
            if brackets {
                string += "(\(asString))"
            } else {
                string += asString
            }
        }
        
        return string
    }
    
    func compute(with inputs: [String : Token], format: Bool) -> Token {
        // Compute all values
        var values = self.values.map{ $0.compute(with: inputs, format: format) }.sorted{ $0.getMultiplicationPriority() > $1.getMultiplicationPriority() }
        
        // Some required vars
        var index = 0
        
        // Iterate values
        while index < values.count {
            // Get value
            var value = values[index]
            
            // Check if value is a product
            if let product = value as? Product {
                // Add values to self
                values += product.values
                
                // Remove current value
                values.remove(at: index)
                index -= 1
            } else {
                // Iterate to add it to another value
                var i = 0
                while i < values.count {
                    // Check if it's not the same index
                    if i != index {
                        // Get another value
                        let otherValue = values[i]
                        
                        // Multiply them
                        let product = value.apply(operation: .multiplication, right: otherValue, with: inputs, format: format)
                        
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
            return Number(value: 1)
        }
        
        // Return the simplified product
        return Product(values: values)
    }
    
    func apply(operation: Operation, right: Token, with inputs: [String : Token], format: Bool) -> Token {
        // Compute right
        let right = right.compute(with: inputs, format: format)
        
        // If addition
        if operation == .addition {
            // TODO: Check for common factor
            
            // Add token to sum
            return Sum(values: [self, right])
        }
        
        // If subtraction
        if operation == .subtraction {
            // Add token to sum
            return Sum(values: [self, right.opposite()]).compute(with: inputs, format: format)
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
        return operation.getPrecedence() > Operation.addition.getPrecedence()
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
    
    func asDouble() -> Double? {
        return nil
    }
    
    func getSign() -> FloatingPointSign {
        // To be done
        return .plus
    }
    
}
