//
//  SyntaxError.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

struct SyntaxError: Token, Error {
    
    func toString() -> String {
        return "Syntax error"
    }
    
    func compute(with inputs: [Input]) -> Token {
        return self
    }
    
}
