//
//  Process.swift
//  Delta
//
//  Created by Nathan FALLET on 06/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class Process {
    
    var inputs = [(String, String)]()
    var variables = [String: Token]()
    var outputs = [String]()
    
    init(inputs: [(String, String)]) {
        self.inputs = inputs
    }
    
    func set(identifier: String, to value: Token) {
        let f = identifier.trimmingCharacters(in: CharacterSet(charactersIn: " ")).groups(for: "([\(TokenParser.variables)])\\( *([\(TokenParser.variables)]) *\\)")
        if !f.isEmpty {
            // Take it as a function
            variables[f[0][1]] = FunctionDeclaration(variable: f[0][2], token: value)
        } else {
            // Set it as a variable
            variables[identifier.trimmingCharacters(in: CharacterSet(charactersIn: " "))] = value.compute(with: variables, format: false)
        }
    }
    
}
