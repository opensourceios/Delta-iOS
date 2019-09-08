//
//  CalculError.swift
//  Delta
//
//  Created by Nathan FALLET on 08/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

struct CalculError: Token, Error {
    
    func toString() -> String {
        return "error_calcul".localized()
    }
    
    func compute(with inputs: [Input]) -> Token {
        return self
    }
    
    func getSign() -> FloatingPointSign {
        return .plus
    }
    
    func changedSign() -> Bool {
        return false
    }
    
}
