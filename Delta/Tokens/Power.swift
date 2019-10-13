//
//  Power.swift
//  Delta
//
//  Created by Nathan FALLET on 13/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

struct Power: Token {
    
    var token: Token
    var power: Token
    
    func toString() -> String {
        return "\(token.needBrackets(for: .power) ? "(\(token.toString()))" : token.toString()) ^ \(power.needBrackets(for: .power) ? "(\(power.toString()))" : power.toString())"
    }
    
    func compute(with inputs: [String : Token]) -> Token {
        let token = self.token.compute(with: inputs)
        let power = self.power.compute(with: inputs)
        
        // Check power
        if let number = power as? Number {
            // x^1 is x
            if number.value == 1 {
                return token
            }
        }
        if let fraction = power as? Fraction {
            // x^1/y is ^y√(x)
            if let number = fraction.inverse().compute(with: inputs) as? Number {
                return Root(token: token, power: number)
            }
        }
        
        return token.apply(operation: .power, right: power, with: inputs)
    }
    
    func apply(operation: Operation, right: Token, with inputs: [String : Token]) -> Token {
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
            return Power(token: token, power: Product(values: [power, right]))
        }
        
        // Root
        if operation == .root {
            return Root(token: self, power: right)
        }
        
        return Expression(left: self, right: right, operation: operation)
    }
    
    func needBrackets(for operation: Operation) -> Bool {
        return operation.getPrecedence() >= Operation.power.getPrecedence()
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
