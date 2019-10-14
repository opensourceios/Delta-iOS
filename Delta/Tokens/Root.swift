//
//  Root.swift
//  Delta
//
//  Created by Nathan FALLET on 13/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

struct Root: Token {
    
    var token: Token
    var power: Token
    
    func toString() -> String {
        return "√(\(token.toString()))"
    }
    
    func compute(with inputs: [String : Token]) -> Token {
        let token = self.token.compute(with: inputs)
        let power = self.power.compute(with: inputs)
        
        return token.apply(operation: .root, right: power, with: inputs)
    }
    
    func apply(operation: Operation, right: Token, with inputs: [String : Token]) -> Token {
        // Compute right
        let right = right.compute(with: inputs)
        
        // Sum
        if operation == .addition {
            return Sum(values: [self, right])
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
        1
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
