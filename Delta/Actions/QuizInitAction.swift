//
//  QuizInitAction.swift
//  Delta
//
//  Created by Nathan FALLET on 17/03/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import Foundation

class QuizInitAction: Action {
    
    var text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    func execute(in process: Process) {
        process.quiz = Quiz(text: text.replaceTokens(in: process))
    }
    
    func toString() -> String {
        return "quiz_init \"\(text.replacingOccurrences(of: "\"", with: "\\\""))\""
    }
    
    func toEditorLines() -> [EditorLine] {
        return [EditorLine(format: "action_quiz_init", category: .quiz, values: [text], movable: true)]
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
    
    func extractInputs() -> [(String, String)] {
        return []
    }
    
}
