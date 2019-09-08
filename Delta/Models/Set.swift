//
//  Set.swift
//  Delta
//
//  Created by Nathan FALLET on 08/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

struct Set: Token {
    
    var values: [Token]
    
    func toString() -> String {
        return "(\(values.map { $0.toString() }.joined(separator: " ; ")))"
    }
    
    func compute(with inputs: [Input]) -> Token {
        return self
    }
    
    func getSign() -> FloatingPointSign {
        return .plus
    }
    
    func changedSign() -> Bool {
        return false
    }
    
    func multiply(by number: Number) -> Set {
        var new = Set(values: [])
        
        for i in values {
            new.values += [number.applyToken(operation: .multiplication, right: i)]
        }
        
        return new
    }
    
    func multiply(by set: Set) -> Token {
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
