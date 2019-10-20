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
    func toLocalizedStrings() -> [String]
    
}
