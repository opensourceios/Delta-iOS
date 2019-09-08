//
//  StringExtension.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

extension String {

    // Localization
    
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }

    func format(_ args : CVarArg...) -> String {
        return String(format: self, locale: .current, arguments: args)
    }

    func format(_ args : [String]) -> String {
        return String(format: self, locale: .current, arguments: args)
    }
    
    // Custom operations
    
    func plus(_ right: String) -> Expression {
        return Expression(left: Variable(name: self), right: Variable(name: right), operation: .addition)
    }
    
    func minus(_ right: String) -> Expression {
        return Expression(left: Variable(name: self), right: Variable(name: right), operation: .subtraction)
    }
    
    func times(_ right: String) -> Expression {
        return Expression(left: Variable(name: self), right: Variable(name: right), operation: .multiplication)
    }
    
    func times(_ right: Token) -> Expression {
        return Expression(left: Variable(name: self), right: right, operation: .multiplication)
    }
    
    func power(_ right: Int) -> Expression {
        return Expression(left: Variable(name: self), right: Number(value: right), operation: .power)
    }
    
    func power(_ right: Token) -> Expression {
        return Expression(left: Variable(name: self), right: right, operation: .power)
    }
    
    func equals(_ right: Int) -> Equation {
        return Equation(left: Variable(name: self), right: Number(value: right), operation: .equals)
    }
    
    func inequals(_ right: Int) -> Equation {
        return Equation(left: Variable(name: self), right: Number(value: right), operation: .inequals)
    }
    
    func greaterThan(_ right: Int) -> Equation {
        return Equation(left: Variable(name: self), right: Number(value: right), operation: .greaterThan)
    }
    
    func lessThan(_ right: Int) -> Equation {
        return Equation(left: Variable(name: self), right: Number(value: right), operation: .lessThan)
    }
    
    // Expression parsing
    
    // Parse an expression
    func parseExpression() -> Token {
        // Store values and operations
        var values = [Token]()
        var ops = [String]()
        var i = 0
        
        do {
            // For each character of the string
            while i < count {
                let current = self[i]
                
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
                    while i < count, let t = Int(self[i]) {
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
                        
                        if let op = ops.removeFirst().toOperation() {
                            values.insert(op.join(left: left, right: right), at: 0)
                        }
                    }
                    
                    // Add current operation
                    ops.insert(current, at: 0)
                    
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
                
                if let op = ops.removeFirst().toOperation() {
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
    
    // Operation
    
    func toOperation() -> Operation? {
        // Iterate values
        for value in [Operation.addition, Operation.subtraction, Operation.multiplication, Operation.division, Operation.power, Operation.set] {
            // If it's the value we want
            if self == value.toString() {
                return value
            }
        }
        
        // Nothing found
        return nil
    }
    
    func exponentize() -> String {
        // Define characters
        let supers = [
            "1": "\u{00B9}",
            "2": "\u{00B2}",
            "3": "\u{00B3}",
            "4": "\u{2074}",
            "5": "\u{2075}",
            "6": "\u{2076}",
            "7": "\u{2077}",
            "8": "\u{2078}",
            "9": "\u{2079}"
        ]

        // Final string and current char status
        var newStr = ""
        var isExp = false
        
        // Iterate string
        for char in self {
            // If exp character
            if char == "^" {
                // Clear space before
                if let last = newStr.last, last == " " {
                    newStr.removeLast()
                }
                
                // Set current as exp
                isExp = true
            } else {
                // If last was exp
                if isExp {
                    // Get character as string
                    let key = String(char)
                    
                    // Check if it's a numpber
                    if supers.keys.contains(key) {
                        // Replace by character
                        newStr.append(Character(supers[key]!))
                    } else if key != " " {
                        // End of number, go back to normal
                        isExp = false
                        newStr.append(char)
                    }
                } else {
                    // Normal state
                    newStr.append(char)
                }
            }
        }
        
        // Return final string
        return newStr
    }
    
    // Subscript
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, count) ..< count]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)), upper: min(count, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }

}
