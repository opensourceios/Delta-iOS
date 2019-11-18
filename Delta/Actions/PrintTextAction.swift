//
//  PrintTextAction.swift
//  Delta
//
//  Created by Nathan FALLET on 23/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class PrintTextAction: Action {
    
    var text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    func execute(in process: Process) {
        // Get output
        var output = text
        
        // Get "" to interprete them
        for group in output.groups(for: "\".*\"") {
            // Get token based on string
            let token = TokenParser(group[0][1 ..< group[0].count-1]).execute()
            
            // Replace with tokens
            if let range = output.range(of: group[0]) {
                output = output.replacingCharacters(in: range, with: token.compute(with: process.variables, format: true).toString())
            }
        }
        
        // Print text
        process.outputs.append(output)
    }
    
    func toString() -> String {
        return "print_text \"\(text.replacingOccurrences(of: "\"", with: "\\\""))\""
    }
    
    func toEditorLines() -> [EditorLine] {
        return [EditorLine(format: "action_print_text", category: .output, values: [text])]
    }
    
    func editorLinesCount() -> Int {
        return 1
    }
    
    func action(at index: Int, parent: Action, parentIndex: Int) -> (Action, Action, Int) {
        return (self, parent, parentIndex)
    }
    
    func update(line: EditorLine) {
        if line.values.count == 1 {
            self.text = line.values[0]
        }
    }
    
    func extractInputs() -> [(String, Token)] {
        return []
    }
    
}
