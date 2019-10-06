//
//  Intermediate.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class Intermediate: Input {
    
    var original: Token
    
    override init(name: String, expression: Token) {
        original = expression
        super.init(name: name, expression: expression)
    }
    
    func clear() {
        expression = original
    }
    
    func update(with inputs: [String: Token]) {
        expression = original.compute(with: inputs)
    }
    
}
