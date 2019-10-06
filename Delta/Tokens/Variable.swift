//
//  Variable.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

struct Variable: Token {

    var name: String

    func toString() -> String {
        return "\(name)"
    }
    
    func compute(with inputs: [String: Token]) -> Token {
        // Chech if an input corresponds to this variable
        if let value = inputs[name] {
            return value
        }
        
        // No input found
        return self
    }
    
    func apply(operation: Operation, right: Token, with inputs: [String: Token]) -> Token {
        return Expression(left: self, right: right, operation: operation)
    }
    
    func needBrackets(for operation: Operation) -> Bool {
        return false
    }
    
    func getMultiplicationPriority() -> Int {
        return 2
    }
    
    func getSign() -> FloatingPointSign {
        return .plus
    }
    
    mutating func changedSign() -> Bool {
        return false
    }

}
