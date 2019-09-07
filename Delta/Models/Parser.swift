//
//  Parser.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class Parser {
    
    // Parse an expression
    static func parseExpression(tokens: String) -> Token {
        // Store values and operations
        var values = [Token]()
        var ops = [String]()
        var i = 0
        
        do {
            // For each character of the string
            while i < tokens.count {
                let current = tokens[i]
                
                // Skip whitespace
                if current == " " {
                    // Do nothing
                }
                
                // Opening brace
                else if current == "(" {
                    // Add it to operations
                    ops.insert(current, at: 0)
                }
                
                // Number
                else if Int(current) != nil {
                    var val = 0
                    
                    // Get other digits
                    while i < tokens.count, let t = Int(tokens[i]) {
                        val = (val * 10) + t
                        i += 1
                    }
                    
                    // Insert into values
                    values.insert(Number(value: val), at: 0)
                    
                    // Remove one, else current caracter is skept
                    i -= 1
                }
                    
                // Variable
                else if "abcdefghijklmnopqrstuvwxyz".contains(current) {
                    let variable = Variable(name: current)
                    
                    // Check if we have a token before without operator
                    if values.count > 0 && ops.count == values.count - 1 {
                        // Concatenate them
                        let left = try values.getFirstTokenAndRemove()
                        values.insert(Expression(left: left, right: variable, operation: .multiplication), at: 0)
                    } else {
                        // Insert into values
                        values.insert(variable, at: 0)
                    }
                }
                
                // Closing brace
                else if current == ")" {
                    // Create the token
                    while !ops.isEmpty && ops.first != "(" {
                        let right = try values.getFirstTokenAndRemove()
                        let left = try values.getFirstTokenAndRemove()
                        
                        if let op = ops.removeFirst().toOperation() {
                            values.insert(Expression(left: left, right: right, operation: op), at: 0)
                        }
                    }
                    
                    // Remove opening brace
                    if !ops.isEmpty {
                        ops.removeFirst()
                    }
                }
                
                // Operation
                else {
                    // While first operation has same or greater precendence to current, apply to two first values
                    while !ops.isEmpty, let p1 = ops.first?.toOperation()?.getPrecedence(), let p2 = current.toOperation()?.getPrecedence(), p1 >= p2 {
                        let right = try values.getFirstTokenAndRemove()
                        let left = try values.getFirstTokenAndRemove()
                        
                        if let op = ops.removeFirst().toOperation() {
                            values.insert(Expression(left: left, right: right, operation: op), at: 0)
                        }
                    }
                    
                    // Add current operation
                    ops.insert(current, at: 0)
                }
                
                // Increment i
                i += 1
            }
            
            // Entire expression parsed, apply remaining values
            while !ops.isEmpty {
                let right = try values.getFirstTokenAndRemove()
                let left = try values.getFirstTokenAndRemove()
                
                if let op = ops.removeFirst().toOperation() {
                    values.insert(Expression(left: left, right: right, operation: op), at: 0)
                }
            }
            
            // Return token
            if let token = values.first {
                return token
            }
        } catch {
            // We have a syntax error, do nothing
        }
        
        // If the token is not valid
        return SyntaxError()
    }
    
}
