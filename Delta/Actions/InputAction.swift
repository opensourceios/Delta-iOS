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
        process.variables[identifier] = process.inputs[identifier]?.compute(with: process.variables, format: false)
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
    
    func update(line: EditorLine, at index: Int) {
        if line.values.count == 2 {
            self.identifier = line.values[0]
            self.value = TokenParser(line.values[1]).execute()
        }
    }
    
    func extractInputs() -> [(String, Token)] {
        return [(identifier, value)]
    }
    
}
