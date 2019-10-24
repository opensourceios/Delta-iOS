//
//  ActionBlock.swift
//  Delta
//
//  Created by Nathan FALLET on 21/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

protocol ActionBlock: Action {
    
    func append(actions: [Action])
    func insert(action: Action, at index: Int)
    func delete(at index: Int)
    
}
