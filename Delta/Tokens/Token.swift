//
//  Token.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

protocol Token {
    
    func toString() -> String
    func compute(with inputs: [String: Token]) -> Token
    func apply(operation: Operation, right: Token, with inputs: [String: Token]) -> Token
    func needBrackets(for operation: Operation) -> Bool
    func getMultiplicationPriority() -> Int
    func getSign() -> FloatingPointSign
    mutating func changedSign() -> Bool
    
}
