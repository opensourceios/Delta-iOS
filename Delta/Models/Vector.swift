//
//  Vector.swift
//  Delta
//
//  Created by Nathan FALLET on 08/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

struct Vector: Token {
    
    var values: [Token]
    
    func toString() -> String {
        return "(\(values.map { $0.toString() }.joined(separator: " ; ")))"
    }
    
    func compute(with inputs: [Input]) -> Token {
        return self
    }
    
    func apply(operation: Operation, right: Token, with inputs: [Input]) -> Token {
        return Expression(left: self, right: right, operation: operation)
    }
    
    func getSign() -> FloatingPointSign {
        return .plus
    }
    
    func changedSign() -> Bool {
        return false
    }
    
    func multiply(by number: Number) -> Vector {
        var new = Vector(values: [])
        
        for i in values {
            new.values += [number.apply(operation: .multiplication, right: i, with: [])]
        }
        
        return new
    }
    
    func multiply(by set: Vector) -> Token {
        if values.count != set.values.count {
            return CalculError()
        }
        
        var news = [Token]()
        
        for i in 0 ..< values.count {
            news.insert(Expression(left: values[i], right: set.values[i], operation: .multiplication), at: 0)
        }
        
        do {
            while news.count > 1 {
                let left = try news.getFirstTokenAndRemove()
                let right = try news.getFirstTokenAndRemove()
                
                news.insert(Expression(left: left, right: right, operation: .addition), at: 0)
            }
            
            return news.first!.compute(with: [])
        } catch {
            // Error, do nothing
        }
        
        return SyntaxError()
    }
    
}
