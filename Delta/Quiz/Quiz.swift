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
    var elements = [QuizElement]()
    
    init(text: String) {
        self.text = text
    }
    
    func addQuestion(_ text: String, correct: Token) {
        elements.append(QuizQuestion(text, correct: correct))
    }
    
    func addParagraph(_ text: String) {
        elements.append(QuizParagraph(text: text))
    }
    
}
