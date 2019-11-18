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
    var value: String
    
    init(_ identifier: String, to value: String) {
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
        process.set(identifier: identifier, to: TokenParser(value, in: process).execute())
    }
    
    func toString() -> String {
        return "\("set") \"\(identifier)\" to \"\(value)\""
    }
    
    func toEditorLines() -> [EditorLine] {
        return [EditorLine(format: "action_set", category: .variable, values: [identifier, value])]
    }
    
    func editorLinesCount() -> Int {
        return 1
    }
    
    func action(at index: Int, parent: Action, parentIndex: Int) -> (Action, Action, Int) {
        return (self, parent, parentIndex)
    }
    
    func update(line: EditorLine) {
        if line.values.count == 2 {
            self.identifier = line.values[0]
            self.value = line.values[1]
        }
    }
    
    func extractInputs() -> [(String, String)] {
        return []
    }
    
}
