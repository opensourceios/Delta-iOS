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
    var indentation: Int
    var values: [String]
    var type: EditorLineType
    
    init(format: String, indentation: Int = 0, values: [String] = [], type: EditorLineType = .action) {
        self.format = format
        self.indentation = indentation
        self.values = values
        self.type = type
    }
    
    func incrementIndentation() -> EditorLine {
        indentation += 1
        
        return self
    }
    
}
