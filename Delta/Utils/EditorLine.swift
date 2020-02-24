//
//  EditorLine.swift
//  Delta
//
//  Created by Nathan FALLET on 20/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class EditorLine {
    
    var format: String
    var category: EditorLineCategory
    var indentation: Int
    var values: [String]
    var movable: Bool
    
    init(format: String, category: EditorLineCategory, indentation: Int = 0, values: [String] = [], movable: Bool) {
        self.format = format
        self.category = category
        self.indentation = indentation
        self.values = values
        self.movable = movable
    }
    
    func incrementIndentation() -> EditorLine {
        indentation += 1
        
        return self
    }
    
}
