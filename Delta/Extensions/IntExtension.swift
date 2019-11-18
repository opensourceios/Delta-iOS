//
//  IntExtension.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

extension Int {
    
    // Greatest common divisor
    
    func greatestCommonDivisor(with number: Int) -> Int {
        var a = self
        var b = number
        
        while b != 0 {
            (a, b) = (b, a % b)
        }
        
        return a
    }
    
    // Check for power of ten
    
    func isPowerOfTen() -> Bool {
        var input = self
        
        while input > 9 && input % 10 == 0 {
            input /= 10
        }
        
        return input == 1;
    }
    
}
