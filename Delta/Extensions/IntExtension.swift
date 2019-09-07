//
//  IntExtension.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

extension Int {
    
    // Custom operations
    
    func times(_ right: String) -> Expression {
        return Expression(left: Number(value: self), right: Variable(name: right), operation: .multiplication)
    }
    
    func times(_ right: Token) -> Expression {
        return Expression(left: Number(value: self), right: right, operation: .multiplication)
    }
    
    func divides(_ right: Int) -> Expression {
        return Expression(left: Number(value: self), right: Number(value: right), operation: .division)
    }
    
}
