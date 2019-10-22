//
//  AlgorithmExtension.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

extension Algorithm {
    
    // Array of all algorithms
    static let array: [Algorithm] = [
        .secondDegreeEquation
    ]
    
    // 2nd degree equation
    static let secondDegreeEquation = AlgorithmParser(-1, named: "algo1_name".localized(), with: """
    input "a" default "1"
    input "b" default "7"
    input "c" default "12"
    if "a != 0" {
        set "Δ" to "b ^ 2 - 4ac"
        set "α" to "(-b) / (2a)"
        set "β" to "(-Δ) / (4a)"
        set_formatted "f(x)" to "ax ^ 2 + bx + c"
        print "f(x)"
        set_formatted "f(x)" to "a(x - α) ^ 2 + β"
        print "f(x)"
        print "Δ"
        if "Δ = 0" {
            set "x_0" to "α"
            print "x_0"
            set_formatted "f(x)" to "a(x - x_0) ^ 2"
            print "f(x)"
        } else {
            set "x_1" to "(-b - √(Δ)) / (2a)"
            set "x_2" to "(-b + √(Δ)) / (2a)"
            print "x_1"
            print "x_2"
            set_formatted "f(x)" to "a(x - x_1)(x - x_2)"
            print "f(x)"
        }
    }
    """).execute()
    
    // Vectors
    static let vectors = AlgorithmParser(-2, named: "algo2_name".localized(), with: """
    input "u" default "(1;2)"
    input "v" default "(3;4)"
    input "w" default "u+v"
    print "w"
    """).execute()
    
    // Statistics
    static let statistics = AlgorithmParser(-3, named: "algo3_name".localized(), with: """
    input "l" default "{1,2,3,4}"
    set "s" to "0"
    set "n" to "0"
    for "x" in "l" {
        set "s" to "s+x"
        set "n" to "n+1"
    }
    set "m" to "s/n"
    print "m"
    print "s"
    print "n"
    """).execute()
    
    // Parse testing
    static let test = AlgorithmParser(-4, named: "Test", with: """
    input "λ" default "0"
    print "λ"
    """).execute()
    
}
