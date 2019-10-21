//
//  SetAction.swift
//  Delta
//
//  Created by Nathan FALLET on 06/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class SetAction: Action {
    
    var identifier: String
    var value: Token
    var format: Bool
    
    init(_ identifier: String, to value: Token, format: Bool = false) {
        self.identifier = identifier
        self.value = value
        self.format = format
    }
    
    func execute(in process: Process) {
        // Check if variable is not a constant
        if Parser.constants.contains(identifier) {
            process.outputs.append("error_constant".localized().format(identifier))
            return
        }
        
        // Set value with process environment
        process.variables[identifier] = value.compute(with: process.variables, format: format)
    }
    
    func toString() -> String {
        return "\(format ? "set_formatted" : "set") \(identifier) to \(value.toString())"
    }
    
    func toEditorLines() -> [EditorLine] {
        return [EditorLine(format: (format ? "action_set_formatted" : "action_set").localized(), values: [identifier, value.toString()])]
    }
    
    func editorLinesCount() -> Int {
        return 1
    }
    
    func update(line: EditorLine, at index: Int) {
        if line.values.count == 2 {
            self.identifier = line.values[0]
            self.value = Parser(line.values[1]).execute()
        }
    }
    
}
