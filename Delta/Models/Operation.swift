//
//  Operation.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

enum Operation {
    
    // Values
    case addition, subtraction, multiplication, division
    
    // Convert to string
    func toString() -> String {
        switch self {
        case .addition:
            return "+"
        case .subtraction:
            return "-"
        case .multiplication:
            return "*"
        case .division:
            return "/"
        }
    }
    
    // Get precedence
    func getPrecedence() -> Int {
        if self == .multiplication || self == .division {
            return 2
        }
        return 1
    }
    
}
