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
    
    func compute(with inputs: [Input]) -> Token {
        // Chech if an input corresponds to this variable
        for input in inputs {
            if name == input.name {
                return input.expression.compute(with: [])
            }
        }
        
        // No input found
        return self
    }

}
