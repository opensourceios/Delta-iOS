//
//  ArrayExtension.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

extension Array {
    
    mutating func getFirstTokenAndRemove() throws -> Token {
        // Check if exists
        if count > 0, let token = first as? Token {
            removeFirst()
            return token
        }
        
        // Return a syntax error
        throw SyntaxError()
    }
    
}
