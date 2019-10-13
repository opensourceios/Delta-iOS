//
//  Fraction.swift
//  Delta
//
//  Created by Nathan FALLET on 09/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

struct Fraction: Token {
    
    var numerator: Token
    var denominator: Token
    
    func toString() -> String {
        return "\(numerator.needBrackets(for: .division) ? "(\(numerator.toString()))" : numerator.toString()) / \(denominator.needBrackets(for: .division) ? "(\(denominator.toString()))" : denominator.toString())"
    }
    
    func compute(with inputs: [String : Token]) -> Token {
        let numerator = self.numerator.compute(with: inputs)
        let denominator = self.denominator.compute(with: inputs)
        
        // Check numerator
        if let number = numerator as? Number {
            // 0/x is 0
            if number.value == 0 {
                return number
            }
        }
        
        // Check denominator
        if let number = denominator as? Number {
            // x/1 is x
            if number.value == 1 {
                return numerator
            }
            
            // x/0 is calcul error
            if number.value == 0 {
                return CalculError()
            }
        }
        
        // Apply to simplify
        return numerator.apply(operation: .division, right: denominator, with: inputs)
    }
    
    func apply(operation: Operation, right: Token, with inputs: [String : Token]) -> Token {
        // If addition
        if operation == .addition {
            // Add token to sum
            return Sum(values: [self, right])
        }
        
        // If product
        if operation == .multiplication {
            // Add token to product
            return Product(values: [self, right])
        }
        
        // If fraction
        if operation == .division {
            // Multiply by its inverse
            return Product(values: [self, right.inverse()])
        }
        
        // Power
        if operation == .power {
            return Fraction(numerator: Power(token: numerator, power: right), denominator: Power(token: denominator, power: right))
        }
        
        // Root
        if operation == .root {
            return Fraction(numerator: Root(token: numerator, power: right), denominator: Root(token: denominator, power: right))
        }
        
        // Unknown, return an exoression
        return Expression(left: self, right: right, operation: operation)
    }
    
    func needBrackets(for operation: Operation) -> Bool {
        return operation.getPrecedence() >= Operation.division.getPrecedence()
    }
    
    func getMultiplicationPriority() -> Int {
        return 1
    }
    
    func opposite() -> Token {
        return Fraction(numerator: Product(values: [Number(value: -1), numerator]), denominator: denominator)
    }
    
    func inverse() -> Token {
        return Fraction(numerator: denominator, denominator: numerator)
    }
    
    func getSign() -> FloatingPointSign {
        return .plus
    }
    
}
