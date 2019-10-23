//
//  Modulo.swift
//  Delta
//
//  Created by Nathan FALLET on 23/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

struct Modulo: Token {
    
    var dividend: Token
    var divisor: Token
    
    func toString() -> String {
        return "\(dividend.needBrackets(for: .division) ? "(\(dividend.toString()))" : dividend.toString()) % \(divisor.needBrackets(for: .division) ? "(\(divisor.toString()))" : divisor.toString())"
    }
    
    func compute(with inputs: [String : Token], format: Bool) -> Token {
        let dividend = self.dividend.compute(with: inputs, format: format)
        let divisor = self.divisor.compute(with: inputs, format: format)
        
        // Check dividend
        if let number = dividend as? Number {
            // 0 % x is 0
            if number.value == 0 {
                return number
            }
        }
        
        // Check divisor
        if let number = divisor as? Number {
            // x % 1 is 0
            if number.value == 1 {
                return Number(value: 0)
            }
            
            // x % 0 is calcul error
            if number.value == 0 {
                return CalculError()
            }
        }
        
        // Apply to simplify
        return dividend.apply(operation: .modulo, right: divisor, with: inputs, format: format)
    }
    
    func apply(operation: Operation, right: Token, with inputs: [String : Token], format: Bool) -> Token {
        // Compute right
        let right = right.compute(with: inputs, format: format)
        
        // If addition
        if operation == .addition {
            // Right is a sum
            if let right = right as? Sum {
                return Sum(values: right.values + [self])
            }
            
            // Return the sum
            return Sum(values: [self, right])
        }
        
        // If subtraction
        if operation == .subtraction {
            // Return the sum
            return Sum(values: [self, right.opposite()])
        }
        
        // If product
        if operation == .multiplication {
            // Right is a product
            if let right = right as? Product {
                return Product(values: right.values + [self])
            }
            
            // Return the product
            return Product(values: [self, right])
        }
        
        // If fraction
        if operation == .division {
            // Return the fraction
            return Fraction(numerator: self, denominator: right)
        }
        
        // Modulo
        if operation == .modulo {
            // Return the modulo
            return Modulo(dividend: self, divisor: right)
        }
        
        // Power
        if operation == .power {
            // Return the power
            return Power(token: self, power: right)
        }
        
        // Root
        if operation == .root {
            // Return root
            return Root(token: self, power: right)
        }
        
        // Unknown, return a calcul error
        return CalculError()
    }
    
    func needBrackets(for operation: Operation) -> Bool {
        return operation.getPrecedence() >= Operation.division.getPrecedence()
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
    
    func asDouble() -> Double? {
        if let dividend = dividend.asDouble(), let divisor = divisor.asDouble() {
            return dividend/divisor
        }
        
        return nil
    }
    
    func getSign() -> FloatingPointSign {
        return .plus
    }
    
}
