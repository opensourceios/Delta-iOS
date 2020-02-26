//
//  AlgorithmExtension.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

extension Algorithm {
    
    // Array of default algorithms
    static let defaults: [Algorithm] = [
        .secondDegreeEquation
    ]
    
    // 2nd degree equation
    static let secondDegreeEquation = AlgorithmParser(0, remote_id: 1, owned: false, named: "2nd degree equations", last_update: Date(timeIntervalSince1970: 0), icon: AlgorithmIcon(icon: "function", color: "river"), with: "print_text \"Updating from server...\"").execute()
    
}
