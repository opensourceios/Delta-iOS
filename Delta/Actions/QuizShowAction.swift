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
        if let quiz = process.quiz {
            // Create the semaphore for thread management
            let semaphore = DispatchSemaphore(value: 0)
            
            // Show quiz to user
            DispatchQueue.main.async {
                
                DispatchQueue.global().async {
                    // Add it to outputs
                    process.outputs.append(quiz)
                    
                    // And continue process
                    semaphore.signal()
                }
            }
            
            // Wait for quiz to finish
            semaphore.wait()
            semaphore.signal()
        }
        
        // Reset quiz
        process.quiz = nil
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
