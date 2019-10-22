//
//  PrintAction.swift
//  Delta
//
//  Created by Nathan FALLET on 06/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class PrintAction: Action {
    
    var identifier: String
    
    init(_ identifier: String) {
        self.identifier = identifier
    }
    
    func execute(in process: Process) {
        // Get the value
        if let value = process.variables[identifier] {
            // Print it (add it to output)
            process.outputs.append("\(identifier) = \(value.toString())")
        }
    }
    
    func toString() -> String {
        return "print \"\(identifier)\""
    }
    
    func toEditorLines() -> [EditorLine] {
        return [EditorLine(format: "action_print".localized(), category: .output, values: [identifier])]
    }
    
    func editorLinesCount() -> Int {
        return 1
    }
    
    func action(at index: Int) -> Action {
        return self
    }
    
    func update(line: EditorLine) {
        if line.values.count == 1 {
            self.identifier = line.values[0]
        }
    }
    
    func extractInputs() -> [(String, Token)] {
        return []
    }
    
}
