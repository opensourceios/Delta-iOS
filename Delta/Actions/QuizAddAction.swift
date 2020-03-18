//
//  QuizAddAction.swift
//  Delta
//
//  Created by Nathan FALLET on 17/03/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import Foundation

class QuizAddAction: Action {
    
    var text: String
    var correct: String
    
    init(_ text: String, correct: String) {
        self.text = text
        self.correct = correct
    }
    
    func execute(in process: Process) {
        if let quiz = process.quiz {
            quiz.addQuestion(text, correct: correct)
        }
    }
    
    func toString() -> String {
        return "quiz_add \"\(text)\" correct \"\(correct)\""
    }
    
    func toEditorLines() -> [EditorLine] {
        return [EditorLine(format: "action_quiz_add", category: .quiz, values: [text, correct], movable: true)]
    }
    
    func editorLinesCount() -> Int {
        return 1
    }
    
    func action(at index: Int, parent: Action, parentIndex: Int) -> (Action, Action, Int) {
        return (self, parent, parentIndex)
    }
    
    func update(line: EditorLine) {
        if line.values.count == 2 {
            self.text = line.values[0]
            self.correct = line.values[1]
        }
    }
    
    func extractInputs() -> [(String, String)] {
        return []
    }
    
}
