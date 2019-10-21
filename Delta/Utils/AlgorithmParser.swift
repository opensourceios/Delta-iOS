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
                // Some vars
                i += 1
                var content = ""
                var count = 0
                
                // Get text until its closing brace
                while lines[i] != "}" || count != 0 {
                    // Add current
                    content += lines[i]
                    
                    // Check for another opening brace
                    if lines[i] == "{" {
                        count += 1
                    }
                    
                    // Closing
                    if lines[i] == "}" {
                        count -= 1
                    }
                    
                    // Increment i
                    i += 1
                }
                
                // Parse block
                let block = AlgorithmParser(content).execute()
                
                // Create an action from the line
                if let action = createAction() as? ActionBlock {
                    // Add braces actions
                    action.append(actions: block)
                    
                    // If it is an ElseAction
                    if let elseAction = action as? ElseAction {
                        // Check for IfAction
                        if let ifAction = actions.first as? IfAction {
                            // Set elseAction
                            ifAction.elseAction = elseAction
                        }
                    } else {
                        // Add it to the list
                        actions.insert(action, at: 0)
                    }
                }
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
                i += 1
                
                // Get all the characters
                while i < lines.count && lines[i] != "\"" {
                    token += lines[i]
                    i += 1
                }
                
                // Insert into tokens
                tokens.insert(token, at: 0)
            }
            
            // New line not in braces
            else if current == "\n" && !keywords.contains("{") {
                // Create an action from the line
                if let action = createAction() {
                    // Add it to the list
                    actions.insert(action, at: 0)
                }
            }
            
            // Increment i
            i += 1
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
            let grouped = [Keyword.In: [Keyword.For], Keyword.To: [Keyword.Set, Keyword.SetFormatted]]
            
            // Iterate values
            for key in grouped {
                // If it's the keyword we want
                if first == key.key.rawValue {
                    // Get the next one
                    if let second = keywords.first {
                        // Remove it too
                        keywords.removeFirst()
                        
                        // Iterate values
                        for value in key.value {
                            // Check if second is the correct value
                            if second == value.rawValue {
                                // Create action and return it
                                if value == .For && tokens.count >= 2 {
                                    // For "identifier" in "token"
                                    let token = TokenParser(tokens.removeFirst()).execute()
                                    let identifier = tokens.removeFirst()
                                    return ForAction(identifier, in: token, do: [])
                                } else if value == .Set && tokens.count >= 2 {
                                    // Set "identifier" to "token"
                                    let token = TokenParser(tokens.removeFirst()).execute()
                                    let identifier = tokens.removeFirst()
                                    return SetAction(identifier, to: token)
                                } else if value == .SetFormatted && tokens.count >= 2 {
                                    // Set "identifier" to "token" as format
                                    let token = TokenParser(tokens.removeFirst()).execute()
                                    let identifier = tokens.removeFirst()
                                    return SetAction(identifier, to: token, format: true)
                                }
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
                        let condition = TokenParser(tokens.removeFirst()).execute()
                        return IfAction(condition, do: [])
                    } else if value == .Else {
                        // Else
                        return ElseAction(do: [])
                    } else if value == .Print && tokens.count >= 1 {
                        // Print "identifier"
                        let identifier = tokens.removeFirst()
                        return PrintAction(identifier)
                    } else if value == .While && tokens.count >= 1 {
                        // While "condition"
                        let condition = TokenParser(tokens.removeFirst()).execute()
                        return WhileAction(condition, do: [])
                    }
                }
            }
        }
        
        // Nothing found
        return nil
    }
    
}
