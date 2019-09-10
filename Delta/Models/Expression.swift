//
//  Expression.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

struct Expression: Token {
    
    var left: Token
    var right: Token
    var operation: Operation
    
    func shouldInvert() -> Bool {
        return operation == .multiplication && self.right.getMultiplicationPriority() > self.left.getMultiplicationPriority()
    }
    
    func toString() -> String {
        // Definition
        let left = shouldInvert() ? self.right : self.left
        let right = shouldInvert() ? self.left : self.right
        
        let bleft = left.needBrackets(for: operation)
        let bright = right.needBrackets(for: operation)
        
        var result = ""
        
        // Brackets on the left
        if bleft {
            result += "(\(left.toString()))"
        } else {
            result += "\(left.toString())"
        }
        
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
                if right.operation == .power {
                    // Don't add it
                    op = false
                }
                if right.operation == .multiplication && right.left as? Variable != nil {
                    // Don't add it
                    op = false
                }
            }
        }
        
        // Add it
        if op {
            result += " \(operation.toString()) "
        }
        
        // Brackets on the right
        if bright {
            result += "(\(right.toString()))"
        } else {
            result += "\(right.toString())"
        }
        
        // Return result
        return result
    }
    
    func compute(with inputs: [Input]) -> Token {
        // Compute expression terms
        let left = shouldInvert() ? self.right.compute(with: inputs) : self.left.compute(with: inputs)
        var right = shouldInvert() ? self.left.compute(with: inputs) : self.right.compute(with: inputs)
        
        // Check if any error
        if left as? SyntaxError != nil || right as? SyntaxError != nil {
            // Return it
            return SyntaxError()
        }
        
        // Right is negative and sign can be changed
        if right.getSign() == .minus && (operation == .addition || operation == .subtraction) && right.changedSign() {
            return Expression(left: left, right: right, operation: operation == .addition ? .subtraction : .addition).compute(with: inputs)
        }
        
        // Can't join left and right, return it
        return left.apply(operation: operation, right: right, with: inputs)
    }
    
    func apply(operation: Operation, right: Token, with inputs: [Input]) -> Token {
        // Compute right
        let right = right.compute(with: inputs)
        
        // Right is a number
        if let right = right as? Number {
            // If right is 1
            if right.value == 1 && (operation == .multiplication || operation == .division || operation == .power) {
                // It's 1 time self, return self
                return self
            }
            
            // If right is 0
            if right.value == 0 {
                // x * 0 is 0
                if operation == .multiplication {
                    return Number(value: 0)
                }
                // x / 0 is error
                if operation == .division {
                    return CalculError()
                }
                // x ^ 0 is 1
                if operation == .power {
                    return Number(value: 1)
                }
                // x + 0 or x - 0 is x
                if operation == .addition || operation == .subtraction {
                    return self
                }
            }
            
            // Addition
            if operation == .addition {
                // On addition
                if self.operation == .addition {
                    // Check which one can be added
                    
                }
                
                // On subtraction
                if self.operation == .subtraction {
                    // Check which one can be added (or removed)
                    
                }
                
                // On division
                if self.operation == .division {
                    // Check and multiply by bottom and add to top
                    
                }
            }
            
            // Subtraction
            if operation == .subtraction {
                
            }
            
            // Multiplication
            if operation == .multiplication {
                
            }
            
            // Division
            if operation == .division {
                
            }
            
            // Power
            if operation == .power {
                
            }
        }
        
        return Expression(left: self, right: right, operation: operation)
    }
    
    func needBrackets(for operation: Operation) -> Bool {
        return operation.getPrecedence() > self.operation.getPrecedence()
    }
    
    func getMultiplicationPriority() -> Int {
        return 1
    }
    
    func getSign() -> FloatingPointSign {
        if operation == .addition {
            if left.getSign() == .plus && right.getSign() == .plus {
                return .plus
            }
        } else if operation == .subtraction {
            
        } else if operation == .multiplication || operation == .division {
            if (left.getSign() == .plus && right.getSign() == .plus) || (left.getSign() == .minus && right.getSign() == .minus) {
                return .plus
            } else {
                return .minus
            }
        } else if operation == .power {
            if left.getSign() == .plus {
                return .plus
            } else if left.getSign() == .minus, let right = right as? Number, right.value % 2 == 0 {
                return .plus
            } else {
                return .minus
            }
        }
        
        return .plus
    }
    
    mutating func changedSign() -> Bool {
        if operation == .multiplication || operation == .division {
            if left.changedSign() {
                return true
            } else if right.changedSign() {
                return true
            }
        }
        
        return false
    }
    
    func plus(_ right: String) -> Expression {
        return Expression(left: self, right: Variable(name: right), operation: .addition)
    }
    
    func plus(_ right: Token) -> Expression {
        return Expression(left: self, right: right, operation: .addition)
    }
    
    func minus(_ right: Token) -> Expression {
        return Expression(left: self, right: right, operation: .subtraction)
    }
    
    func times(_ right: String) -> Expression {
        return Expression(left: self, right: Variable(name: right), operation: .multiplication)
    }
    
    func times(_ right: Token) -> Expression {
        return Expression(left: self, right: right, operation: .multiplication)
    }
    
    func divides(_ right: Token) -> Expression {
        return Expression(left: self, right: right, operation: .division)
    }
    
    func power(_ right: Int) -> Expression {
        return Expression(left: self, right: Number(value: right), operation: .power)
    }
    
}
