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
            
            // Closing brace
            else if current == "}" {
                // Store actions contained in braces
                var inBraces = [Action]()
                
                // Create actions until opening brace
                while !keywords.isEmpty && keywords.first != "{" {
                    // Create an action from the line
                    if let action = createAction() {
                        // Add it to the list
                        inBraces.insert(action, at: 0)
                    }
                }
                
                // Remove opening brace
                if !keywords.isEmpty {
                    keywords.removeFirst()
                }
                
                // Add the brace to the block
                if let actionBlock = actions.first as? ActionBlock {
                    // Add content to action
                    actionBlock.append(actions: inBraces)
                }
            }
            
            // New line
            else if current == "\n" {
                // Create an action from the line
                if let action = createAction() {
                    // Add it to the list
                    actions.insert(action, at: 0)
                }
            }
        }
        
        // If something left, add it
        while !keywords.isEmpty {
            // Create an action from the line
            if let action = createAction() {
                // Add it to the list
                actions.insert(action, at: 0)
            }
        }
        
        return actions.reversed()
    }
    
    func createAction() -> Action? {
        // Check if first is string
        if let first = keywords.first {
            // Remove it
            keywords.removeFirst()
            
            // Keyword list
            let alone = [Keyword.If, Keyword.Else, Keyword.Print, Keyword.While]
            let grouped = [Keyword.In: Keyword.For, Keyword.To: Keyword.Set]
            
            // Iterate values
            for value in grouped {
                // If it's the keyword we want
                if first == value.key.rawValue {
                    // Get the next one
                    if let second = keywords.first {
                        // Remove it too
                        keywords.removeFirst()
                        
                        // Check if second is the correct value
                        if second == value.value.rawValue {
                            // Create action and return it
                            if value.value == .For && tokens.count >= 2 {
                                // For "identifier" in "token"
                                return ForAction(tokens.removeFirst(), in: TokenParser(tokens.removeFirst()).execute(), do: [])
                            } else if value.value == .Set && tokens.count >= 2 {
                                // Set "identifier" to "token"
                                return SetAction(tokens.removeFirst(), to: TokenParser(tokens.removeFirst()).execute())
                            }
                        }
                    }
                }
            }
            
            // Iterate values
            for value in alone {
                // If it's the keyword we want
                if first == value.rawValue {
                    // Create action and return it
                    if value == .If && tokens.count >= 1 {
                        // If "condition"
                        return IfAction(TokenParser(tokens.removeFirst()).execute(), do: [])
                    } else if value == .Else {
                        // Else
                        return ElseAction(do: [])
                    } else if value == .Print && tokens.count >= 1 {
                        // Print "identifier"
                        return PrintAction(tokens.removeFirst())
                    } else if value == .While && tokens.count >= 1 {
                        // While "condition"
                        return WhileAction(TokenParser(tokens.removeFirst()).execute(), do: [])
                    }
                }
            }
        }
        
        // Nothing found
        return nil
    }
    
}
