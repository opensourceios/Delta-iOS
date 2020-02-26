//
//  AlgorithmIcon.swift
//  Delta
//
//  Created by Nathan FALLET on 26/02/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

class AlgorithmIcon: Codable {
    
    static let defaultIcon = "x"
    static let defaultColor = "river"
    
    var icon: String
    var color: String
    
    init(icon: String? = nil, color: String? = nil) {
        self.icon = icon ?? AlgorithmIcon.defaultIcon
        self.color = color ?? AlgorithmIcon.defaultColor
    }
    
    func getUIImage() -> UIImage? {
        return UIImage(named: "Icon\(icon.capitalizeFirstLetter())") ?? UIImage(named: "Icon\(AlgorithmIcon.defaultIcon.capitalizeFirstLetter())")
    }
    
}
