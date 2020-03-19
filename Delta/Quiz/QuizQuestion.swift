//
//  QuizQuestion.swift
//  Delta
//
//  Created by Nathan FALLET on 18/03/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import Foundation

class QuizQuestion: QuizElement {
    
    var text: String
    var correct: Token
    
    init(_ text: String, correct: Token) {
        self.text = text
        self.correct = correct
    }
    
}
