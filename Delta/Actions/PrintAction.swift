//
//  PrintAction.swift
//  Delta
//
//  Created by Nathan FALLET on 06/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class PrintAction: Action {
    
    var identifier: String
    
    init(_ identifier: String) {
        self.identifier = identifier
    }
    
    func execute(in process: Process) {
        // Get the value
        if let value = process.variables[identifier] {
            // Print it (add it to output)
            process.outputs.append("\(identifier) = \(value.toString())")
        }
    }
    
    func toString() -> String {
        return "print \(identifier)"
    }
    
    func toLocalizedStrings() -> [String] {
        return ["action_print".localized().format(identifier)]
    }
    
}
