//
//  Sum.swift
//  Delta
//
//  Created by Nathan FALLET on 09/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

struct Sum: Token {
    
    var values: [Token]
    
    func toString() -> String {
        // To be optimized (for minus)
        return values.map{ $0.toString() }.joined(separator: " + ")
    }
    
    func compute(with inputs: [String : Token]) -> Token {
        var values = self.values.map{ $0.compute(with: inputs) }
        
        // add values to themselves
        
        return Sum(values: values)
    }
    
    func apply(operation: Operation, right: Token, with inputs: [String : Token]) -> Token {
        
        return Expression(left: self, right: right, operation: .addition)
    }
    
    func needBrackets(for operation: Operation) -> Bool {
        return operation.getPrecedence() > Operation.addition.getPrecedence()
    }
    
    func getMultiplicationPriority() -> Int {
        1
    }
    
    func getSign() -> FloatingPointSign {
        // To be done
        return .plus
    }
    
    func changedSign() -> Bool {
        // To be done
        return false
    }
    
}
