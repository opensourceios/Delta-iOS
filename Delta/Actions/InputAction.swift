//
//  InputAction.swift
//  Delta
//
//  Created by Nathan FALLET on 22/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class InputAction: Action {
    
    var identifier: String
    var value: Token
    
    init(_ identifier: String, default value: Token) {
        self.identifier = identifier
        self.value = value
    }
    
    func execute(in process: Process) {}
    func toString() -> String { return "" }
    func toEditorLines() -> [EditorLine] { return [] }
    func editorLinesCount() -> Int { return 0 }
    func update(line: EditorLine, at index: Int) {}
    
}
