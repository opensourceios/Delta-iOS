//
//  AlgorithmParser.swift
//  Delta
//
//  Created by Nathan FALLET on 21/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class AlgorithmParser {
    
    static let characters = "abcdefghijklmnopqrstuvwxyz_"
    
    var lines: String
    var actions: [Action]
    var keywords: [String]
    var tokens: [String]
    var i: Int
    
    init(_ lines: String?) {
        self.lines = lines ?? ""
        self.actions = [Action]()
        self.keywords = [String]()
        self.tokens = [String]()
        self.i = 0
    }
    
    // Parse an algorithm
    func execute() -> [Action] {
        // For each character of the string
        while i < lines.count {
            let current = lines[i]
            
            // skip whitespace
            if current == " " {
                // Do nothing
            }
            
            // Opening brace
            else if current == "{" {
                // Add it to keywords
                keywords.insert(current, at: 0)
            }
            
            // Characters
            else if AlgorithmParser.characters.contains(current) {
                var keyword = ""
                
                // Get all the characters
                while i < lines.count && AlgorithmParser.characters.contains(lines[i]) {
                    keyword += lines[i]
                    i += 1
                }
                
                // Insert into keywords
                keywords.insert(keyword, at: 0)
                
                // Remove one, else current caracter is skept
                i -= 1
            }
            
            // Tokens
            else if current == "\"" {
                var token = ""
                
                // Get all the characters
                while i < lines.count && (lines[i] != "\"" || token.isEmpty) {
                    token += lines[i]
                    i += 1
                }
                
                // Insert into tokens
                tokens.insert(token, at: 0)
                
                // Remove one, else current caracter is skept
                i -= 1
            }
            
            // New line
            else if current == "\n" {
                
            }
        }
        
        return actions
    }
    
}
