//
//  Variable.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

struct Variable: Token {

    var name: String

    func toString() -> String {
        return "\(name)"
    }
    
    func compute(with inputs: [String: Token], format: Bool) -> Token {
        // Chech if an input corresponds to this variable
        if let value = inputs[name] {
            return value
        }
        
        // No input found
        return self
    }
    
    func apply(operation: Operation, right: Token, with inputs: [String: Token], format: Bool) -> Token {
        // Compute right
        let right = right.compute(with: inputs, format: format)
        
        // Sum
        if operation == .addition {
            return Sum(values: [self, right])
        }
        
        // Difference
        if operation == .subtraction {
            return Sum(values: [self, right.opposite()])
        }
        
        // Product
        if operation == .multiplication {
            return Product(values: [self, right])
        }
        
        // Fraction
        if operation == .division {
            return Fraction(numerator: self, denominator: right)
        }
        
        // Power
        if operation == .power {
            // Check for i
            if name == "i" {
                // If right is a number
                if let number = right as? Number {
                    // i^2 = -1
                    if number.value % 4 == 2 {
                        return Number(value: -1)
                    }
                    // i^3 = -1
                    if number.value % 4 == 3 {
                        return Product(values: [Number(value: -1), self])
                    }
                    // Simplificated power of i
                    return Power(token: self, power: Number(value: number.value % 4)).compute(with: inputs, format: format)
                }
            }
            
            return Power(token: self, power: right)
        }
        
        // Root
        if operation == .root {
            return Root(token: self, power: right)
        }
        
        // Unknown, return a calcul error
        return CalculError()
    }
    
    func needBrackets(for operation: Operation) -> Bool {
        return false
    }
    
    func getMultiplicationPriority() -> Int {
        return 2
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

}
