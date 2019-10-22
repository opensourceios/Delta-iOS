//
//  InputAction.swift
//  Delta
//
//  Created by Nathan FALLET on 22/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class InputAction: Action {
    
    var identifier: String
    var value: Token
    
    init(_ identifier: String, default value: Token) {
        self.identifier = identifier
        self.value = value
    }
    
    func execute(in process: Process) {
        // Check if variable is not a constant
        if TokenParser.constants.contains(identifier) {
            process.outputs.append("error_constant".localized().format(identifier))
            return
        }
        
        // Set value with process environment
        for input in process.inputs {
            // Check key
            if input.0 == identifier {
                process.variables[identifier] = input.1.compute(with: process.variables, format: false)
            }
        }
    }
    
    func toString() -> String {
        return "input \"\(identifier)\" default \"\(value.toString())\""
    }
    
    func toEditorLines() -> [EditorLine] {
        return [EditorLine(format: "action_input".localized(), values: [identifier, value.toString()])]
    }
    
    func editorLinesCount() -> Int {
        return 1
    }
    
    func action(at index: Int) -> Action {
        return self
    }
    
    func update(line: EditorLine) {
        if line.values.count == 2 {
            self.identifier = line.values[0]
            self.value = TokenParser(line.values[1]).execute()
        }
    }
    
    func extractInputs() -> [(String, Token)] {
        return [(identifier, value)]
    }
    
}
