//
//  Function.swift
//  Delta
//
//  Created by Nathan FALLET on 18/11/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

struct Function: Token {
    
    var name: String
    var parameter: Token
    
    func toString() -> String {
        return "\(name)(\(parameter.toString()))"
    }
    
    func compute(with inputs: [String : Token], format: Bool) -> Token {
        // Prepare func handling
        let parameter = self.parameter.compute(with: inputs, format: format)
        var expression: Token
        var variable: String
        
        // Chech if an input corresponds to this variable
        if TokenParser.funcs.contains(name) {
            // Universal func
            
            // Sin
            
            // Cos
            
            // Tan
            
            // Sqrt
            if name == "sqrt" {
                expression = Root(token: Variable(name: "x"), power: Number(value: 2))
                variable = "x"
            }
            
            // Exp
            else if name == "exp" {
                expression = Power(token: Variable(name: "e"), power: Variable(name: "x"))
                variable = "x"
            }
            
            // Log
            
            // Ln
            
            // Random
            if name == "random", let number = parameter as? Number, number.value > 0 {
                return Number(value: Int64.random(in: 0 ..< number.value))
            }
            
            // Cannot be simplified
            else {
                return self
            }
        } else if let value = inputs[name] as? FunctionDeclaration {
            // Custom func
            expression = value.token
            variable = value.variable.trimmingCharacters(in: CharacterSet(charactersIn: " "))
        } else {
            // Unknown func
            return CalculError()
        }
        
        // Get inputs and current parameter of function
        var values = inputs
        if (parameter as? Variable)?.name ?? "" != variable {
            values[variable] = parameter
        }
        
        // Return computed expression
        return expression.compute(with: values, format: format)
    }
    
    func apply(operation: Operation, right: Token, with inputs: [String : Token], format: Bool) -> Token {
        // Compute right
        let right = right.compute(with: inputs, format: format)
        
        // Sum
        if operation == .addition {
            // Right is a sum
            if let right = right as? Sum {
                return Sum(values: right.values + [self])
            }
            
            return Sum(values: [self, right])
        }
        
        // Difference
        if operation == .subtraction {
            return Sum(values: [self, right.opposite()])
        }
        
        // Product
        if operation == .multiplication {
            // Right is a product
            if let right = right as? Product {
                return Product(values: right.values + [self])
            }
            
            return Product(values: [self, right])
        }
        
        // Fraction
        if operation == .division {
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
    
    func asDouble() -> Double? {
        // Chech if an input corresponds to this variable
        if TokenParser.funcs.contains(name), let paramDouble = parameter.asDouble() {
            // Universal func
            
            // Sin
            if name == "sin" {
                return sin(paramDouble)
            }
            
            // Cos
            if name == "cos" {
                return cos(paramDouble)
            }
            
            // Tan
            if name == "tan" {
                return tan(paramDouble)
            }
            
            // Log
            if name == "log" {
                return log10(paramDouble)
            }
            
            // Ln
            if name == "ln" {
                return log(paramDouble)
            }
        }
        
        return nil
    }
    
    func getSign() -> FloatingPointSign {
        return .plus
    }
    
}
