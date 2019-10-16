//
//  ForEachAction.swift
//  Delta
//
//  Created by Nathan FALLET on 07/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class ForEachAction: Action {
    
    var token: Token
    var identifier: String
    var actions: [Action]
    
    init(_ token: Token, as identifier: String, do actions: [Action]) {
        self.token = token
        self.identifier = identifier
        self.actions = actions
    }
    
    func execute(in process: Process) {
        // Get computed token
        let token = self.token.compute(with: process.variables, format: false)
        
        // Get list
        if let list = token as? List {
            // Iterate list
            for element in list.values {
                // Set value
                process.variables[identifier] = element
                
                // Execute actions
                for action in actions {
                    action.execute(in: process)
                }
            }
        }
        
        // Get interval
        // TODO
    }
    
}
