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
    static let secondDegreeEquation = AlgorithmParser(0, remote_id: nil, owned: false, named: "algo1_name".localized(), last_update: Date(), with: """
    input "a" default "1"
    input "b" default "7"
    input "c" default "12"
    if "a != 0" {
        set "Δ" to "b ^ 2 - 4ac"
        set "α" to "(-b) / (2a)"
        set "β" to "(-Δ) / (4a)"
        print_text "f(x) = \\\"ax ^ 2 + bx + c\\\""
        print_text "f(x) = \\\"a(x - α) ^ 2 + β\\\""
        print "Δ"
        if "Δ = 0" {
            set "x_0" to "α"
            print "x_0"
            print_text "f(x) = \\\"a(x - x_0) ^ 2\\\""
        } else {
            set "x_1" to "(-b - √(Δ)) / (2a)"
            set "x_2" to "(-b + √(Δ)) / (2a)"
            print "x_1"
            print "x_2"
            print_text "f(x) = \\\"a(x - x_1)(x - x_2)\\\""
        }
    }
    """).execute()
    
}
