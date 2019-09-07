//
//  Output.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class Output {
    
    var name: String
    var expression: Token
    
    init(name: String, expression: Token) {
        self.name = name
        self.expression = expression
    }
    
    func toString(with inputs: [Input]) -> String {
        return "\(name) \(expression.compute(with: inputs).toString())"
    }
    
}
