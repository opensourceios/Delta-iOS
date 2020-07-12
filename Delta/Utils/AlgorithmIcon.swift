//
//  AlgorithmIcon.swift
//  Delta
//
//  Created by Nathan FALLET on 26/02/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

class AlgorithmIcon: Codable {
    
    // Possible values
    static let valuesIcon = [
        "fraction", "function", "integration", "n", "question", "sigma", "square", "un", "x"
    ]
    static let valuesColor = [
        "emerald", "river", "amethyst", "asphalt", "carrot", "alizarin"
    ]
    
    // Default values
    static let defaultIcon = "x"
    static let defaultColor = "river"
    
    // Properties
    var icon: String
    var color: String
    
    // Initializer
    init(icon: String? = nil, color: String? = nil) {
        self.icon = icon ?? AlgorithmIcon.defaultIcon
        self.color = color ?? AlgorithmIcon.defaultColor
    }
    
}
