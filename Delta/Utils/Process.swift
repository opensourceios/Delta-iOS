//
//  Process.swift
//  Delta
//
//  Created by Nathan FALLET on 06/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class Process {
    
    var variables = [String: Token]()
    var outputs = [String]()
    
    init(inputs: [String: Token]) {
        variables = inputs.mapValues { $0.compute(with: inputs, format: false) }
    }
    
}
