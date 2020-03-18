//
//  Quiz.swift
//  Delta
//
//  Created by Nathan FALLET on 18/03/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import Foundation

class Quiz {
    
    var text: String
    var questions = [(String, String, String)]()
    
    init(text: String) {
        self.text = text
    }
    
    func addQuestion(_ text: String, correct: String) {
        questions.append((text, correct, ""))
    }
    
}
