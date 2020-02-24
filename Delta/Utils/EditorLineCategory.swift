//
//  EditorLineCategory.swift
//  Delta
//
//  Created by Nathan FALLET on 22/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

enum EditorLineCategory: String {
    
    case variable = "variable", structure = "structure", output = "output", settings = "settings", add = "add"
    
    static let list: [EditorLineCategory] = [.variable, .structure, .output]
    
    func catalog() -> [Action] {
        switch self {
        case .variable:
            return [InputAction("a", default: "0"), SetAction("a", to: "0"), UnsetAction("a")]
        case .structure:
            return [IfAction("a = b", do: [], else: ElseAction(do: [])), WhileAction("a = b", do: []), ForAction("a", in: "b", do: [])]
        case .output:
            return [PrintAction("a"), PrintAction("a", approximated: true), PrintTextAction("Hello world!")]
        default:
            return []
        }
    }
    
}
