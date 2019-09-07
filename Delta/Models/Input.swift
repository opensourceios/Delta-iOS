//
//  Input.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class Input {
    
    var name: String
    var expression: Token
    
    init(name: String, expression: Token) {
        self.name = name
        self.expression = expression
    }
    
    func toString() -> String {
        return "\(name) ="
    }
    
}
