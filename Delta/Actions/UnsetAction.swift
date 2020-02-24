//
//  UnsetAction.swift
//  Delta
//
//  Created by Nathan FALLET on 24/02/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import Foundation

class UnsetAction: Action {
    
    var identifier: String
    
    init(_ identifier: String) {
        self.identifier = identifier
    }
    
    func execute(in process: Process) {
        // Check if variable is not a constant
        if TokenParser.constants.contains(identifier) {
            process.outputs.append("error_constant".localized().format(identifier))
            return
        }
        
        // Unset value with process environment
        process.unset(identifier: identifier)
    }
    
    func toString() -> String {
        return "unset \"\(identifier)\""
    }
    
    func toEditorLines() -> [EditorLine] {
        return [EditorLine(format: "action_unset", category: .variable, values: [identifier], movable: true)]
    }
    
    func editorLinesCount() -> Int {
        return 1
    }
    
    func action(at index: Int, parent: Action, parentIndex: Int) -> (Action, Action, Int) {
        return (self, parent, parentIndex)
    }
    
    func update(line: EditorLine) {
        if line.values.count == 1 {
            self.identifier = line.values[0]
        }
    }
    
    func extractInputs() -> [(String, String)] {
        return []
    }
    
}
