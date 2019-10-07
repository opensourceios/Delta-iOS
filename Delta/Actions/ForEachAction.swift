//
//  ForEachAction.swift
//  Delta
//
//  Created by Nathan FALLET on 07/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class ForEachAction: Action {
    
    var list: String
    var identifier: String
    var actions: [Action]
    
    init(_ list: String, as identifier: String, do actions: [Action]) {
        self.list = list
        self.identifier = identifier
        self.actions = actions
    }
    
    func execute(in process: Process) {
        // Get list
        if let list = process.variables[list] as? List {
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
    }
    
}
