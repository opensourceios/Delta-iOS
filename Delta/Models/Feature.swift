//
//  Feature.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

struct Feature {
    
    var name: String
    var inputs: [Input]
    var intermediates: [Intermediate]
    var outputs: [Output]
    
    func getAllInputs() -> [Input] {
        return inputs + intermediates
    }
    
}
