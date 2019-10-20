//
//  Algorithm.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class Algorithm {
    
    var name: String
    var inputs: [String: Token]
    var actions: [Action]
    
    init(name: String, inputs: [String: Token], actions: [Action]) {
        self.name = name
        self.inputs = inputs
        self.actions = actions
    }
    
    func execute() -> Process {
        let process = Process(inputs: inputs)
        
        for action in actions {
            action.execute(in: process)
        }
        
        return process
    }
    
    func toString() -> String {
        return actions.map{ $0.toString() }.joined(separator: "\n")
    }
    
    func toLocalizedStrings() -> [String] {
        return actions.flatMap{ $0.toLocalizedStrings() }
    }
    
}
