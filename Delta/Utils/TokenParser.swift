//
//  TokenParser.swift
//  Delta
//
//  Created by Nathan FALLET on 09/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class TokenParser {
    
    static let variables = "abcdefghijklmnopqrstuvwxyzΑαΒβΓγΔδΕεΖζΗηΘθΙιΚκΛλΜμΝνΞξΟοΠπΣσςϹϲΤτΥυΦφΧχΨψΩω"
    static let variablesAndNumber = "\(variables)0123456789"
    static let productCoefficients = "\(variablesAndNumber))"
    static let constants = "i"
    static let input = " \(variablesAndNumber)_+-*/^√,;(){}=<>!"
    
    private var tokens: String
    private var ops: [String]
    private var i: Int
    
    private var values: [Token]
    
    init(_ tokens: String?) {
        self.tokens = tokens ?? ""
        self.ops = [String]()
        self.i = 0
        
        self.values = [Token]()
    }
    
    // Parse an expression
    func execute() -> Token {
        // Check if empty
        if tokens.isEmpty {
            return Number(value: 0)
        }
        
        do {
            // For each character of the string
            while i < tokens.count {
                let current = tokens[i]
                let previous = i > 0 ? tokens[i-1] : ""
                
                // Skip whitespace
                if current == " " {
                    // Do nothing
                }
                
                // Opening brace
                else if current == "(" {
                    // Check if we have a token before without operator
                    if values.count > 0 && TokenParser.productCoefficients.contains(previous) {
                        // Add a multiplication operator
                        ops.insert("*", at: 0)
                    }
                    
                    // Add it to operations
                    ops.insert(current, at: 0)
                }
                
                // Other opening brace
                else if current == "{" {
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
                    
                    // Check if we have a token before without operator
                    if values.count > 0 && TokenParser.productCoefficients.contains(previous) {
                        // Add a multiplication operator
                        ops.insert("*", at: 0)
                    }
                    
                    // Insert into values
                    values.insert(Number(value: val), at: 0)
                    
                    // Remove one, else current caracter is skept
                    i -= 1
                }
                
                // Variable
                else if TokenParser.variables.contains(current) {
                    // Check name
                    var name = current
                    
                    // Check for an index
                    if i < tokens.count-2 && tokens[i+1] == "_" && TokenParser.variablesAndNumber.contains(tokens[i+2]) {
                        // Add index to variable
                        let index = tokens[i+2]
                        name += "_\(index)"
                        
                        // Increment i 2 times to skip index
                        i += 2
                    }
                    
                    // Init variable
                    let variable = Variable(name: name)

                    // Check if we have a token before without operator
                    if values.count > 0 && TokenParser.productCoefficients.contains(previous) {
                        // Add a multiplication operator
                        ops.insert("*", at: 0)
                    }
                    
                    // Insert into values
                    values.insert(variable, at: 0)
                }
                
                // Closing brace
                else if current == ")" {
                    // Create the token
                    while !ops.isEmpty && ops.first != "(" {
                        let right = try values.getFirstTokenAndRemove()
                        let left = try values.getFirstTokenAndRemove()
                        
                        if let op = ops.getFirstOperationAndRemove() {
                            values.insert(op.join(left: left, right: right), at: 0)
                        }
                    }
                    
                    // Remove opening brace
                    if !ops.isEmpty {
                        ops.removeFirst()
                    }
                }
                
                // Closing brace
                else if current == "}" {
                    // Create the token
                    while !ops.isEmpty && ops.first != "{" {
                        let right = try values.getFirstTokenAndRemove()
                        let left = try values.getFirstTokenAndRemove()
                        
                        if let op = ops.getFirstOperationAndRemove() {
                            values.insert(op.join(left: left, right: right), at: 0)
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
                        
                        if let op = ops.getFirstOperationAndRemove() {
                            values.insert(op.join(left: left, right: right), at: 0)
                        }
                    }
                    
                    // If next if "="
                    if i < tokens.count-1 && tokens[i+1] == "=" {
                        // Add it
                        ops.insert("\(current)=", at: 0)
                        
                        // Increment i
                        i += 1
                    } else {
                        // Add current operation
                        ops.insert(current, at: 0)
                    }
                    
                    // If subtraction with no number before
                    if current == "-" && values.count == 0 {
                        values.insert(Number(value: 0), at: 0)
                    }
                }
                
                // Increment i
                i += 1
            }
            
            // Entire expression parsed, apply remaining values
            while !ops.isEmpty {
                let right = try values.getFirstTokenAndRemove()
                let left = try values.getFirstTokenAndRemove()
                
                if let op = ops.getFirstOperationAndRemove() {
                    values.insert(op.join(left: left, right: right), at: 0)
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
