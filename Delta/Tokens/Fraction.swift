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
        // Compute right
        let right = right.compute(with: inputs)
        
        // If addition
        if operation == .addition {
            // Right is a fraction
            if let right = right as? Fraction {
                // a/b + c/d = (ad+cb)/bd
                return Fraction(numerator: Sum(values: [Product(values: [self.numerator, right.denominator]), Product(values: [right.numerator, self.denominator])]), denominator: Product(values: [self.denominator, right.denominator])).compute(with: inputs)
            }
            
            // Right is anything else
            // a/b + c = (a+cb)/b
            return Fraction(numerator: Sum(values: [self.numerator, Product(values: [right, self.denominator])]), denominator: denominator).compute(with: inputs)
        }
        
        // If product
        if operation == .multiplication {
            // Right is a fraction
            if let right = right as? Fraction {
                // a/b * c/d = ac/bd
                return Fraction(numerator: Product(values: [self.numerator, right.numerator]), denominator: Product(values: [self.denominator, right.denominator])).compute(with: inputs)
            }
            
            // Right is anything else
            // a/b * c = ac/b
            return Fraction(numerator: Product(values: [right, self.numerator]), denominator: denominator).compute(with: inputs).compute(with: inputs)
        }
        
        // If fraction
        if operation == .division {
            // Multiply by its inverse
            return Product(values: [self, right.inverse()]).compute(with: inputs)
        }
        
        // Power
        if operation == .power {
            return Fraction(numerator: Power(token: numerator, power: right), denominator: Power(token: denominator, power: right)).compute(with: inputs)
        }
        
        // Root
        if operation == .root {
            return Fraction(numerator: Root(token: numerator, power: right), denominator: Root(token: denominator, power: right)).compute(with: inputs)
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
        return Fraction(numerator: Product(values: [Number(value: -1), numerator]), denominator: denominator).compute(with: [:])
    }
    
    func inverse() -> Token {
        return Fraction(numerator: denominator, denominator: numerator).compute(with: [:])
    }
    
    func getSign() -> FloatingPointSign {
        return .plus
    }
    
}
