//
//  QuizShowAction.swift
//  Delta
//
//  Created by Nathan FALLET on 17/03/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import Foundation

class QuizShowAction: Action {
    
    func execute(in process: Process) {
        let semaphore = DispatchSemaphore(value: 0)
        
        DispatchQueue.main.async {
            
            DispatchQueue.global().async {
                semaphore.signal()
            }
        }
        
        semaphore.wait()
        semaphore.signal()
    }
    
    func toString() -> String {
        return "quiz_show"
    }
    
    func toEditorLines() -> [EditorLine] {
        return [EditorLine(format: "action_quiz_show", category: .quiz, values: [], movable: true)]
    }
    
    func editorLinesCount() -> Int {
        return 1
    }
    
    func action(at index: Int, parent: Action, parentIndex: Int) -> (Action, Action, Int) {
        return (self, parent, parentIndex)
    }
    
    func update(line: EditorLine) {
        // Nothing to update
    }
    
    func extractInputs() -> [(String, String)] {
        return []
    }
    
}
