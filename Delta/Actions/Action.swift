//
//  Action.swift
//  Delta
//
//  Created by Nathan FALLET on 06/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

protocol Action {
    
    func execute(in process: Process)
    func toString() -> String
    func toEditorLines() -> [EditorLine]
    func editorLinesCount() -> Int
    func action(at index: Int, parent: Action, parentIndex: Int) -> (Action, Action, Int)
    func update(line: EditorLine)
    func extractInputs() -> [(String, Token)]
    
}
