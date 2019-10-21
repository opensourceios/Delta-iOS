//
//  ArrayExtension.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

extension Array {
    
    mutating func getFirstTokenAndRemove() throws -> Token {
        // Check if exists
        if count > 0, let token = first as? Token {
            removeFirst()
            return token
        }
        
        // Return a syntax error
        throw SyntaxError()
    }
    
}

extension Array where Element: StringProtocol {
    
    mutating func getFirstOperationAndRemove() -> Operation? {
        // Check if first is string
        if let first = first as? String {
            // Remove it
            removeFirst()
            
            // Operator list
            var operators = [Operation.addition, Operation.subtraction, Operation.multiplication, Operation.division, Operation.power]
            
            // Check for vectors
            if (self as! [String]).contains("(") {
                operators.append(.vector)
            }
            
            // Check for list
            if (self as! [String]).contains("{") {
                operators.append(.list)
            }
            
            // Iterate values
            for value in operators {
                // If it's the value we want
                if first == value.rawValue {
                    return value
                }
            }
        }
        
        // Nothing found
        return nil
    }
    
}
