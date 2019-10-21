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
        .secondDegreeEquation, .test
    ]
    
    // 2nd degree equation
    static let secondDegreeEquation: Algorithm = {
        let a = Number(value: 1)
        let b = Number(value: 7)
        let c = Number(value: 12)
        
        let actions = AlgorithmParser("""
            print "a"
            print "b"
            print "c"
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
                    set "x_1" to "(-b - (Δ)^(1/2)) / (2a)"
                    set "x_2" to "(-b + (Δ)^(1/2)) / (2a)"
                    print "x_1"
                    print "x_2"
                    set_formatted "f(x)" to "a(x - x_1)(x - x_2)"
                    print "f(x)"
                }
            }
            """).execute()
        
        return Algorithm(name: "algo1_name".localized(), inputs: ["a": a, "b": b, "c": c], actions: actions)
    }()
    
    // Vectors
    static let vectors: Algorithm = {
        let u = Vector(values: [Number(value: 1), Number(value: 2)])
        let v = Vector(values: [Number(value: 3), Number(value: 4)])
        let w = TokenParser.init("u+v").execute()
        
        let actions: [Action] = [
            PrintAction("w")
        ]
        
        return Algorithm(name: "algo2_name".localized(), inputs: ["u": u, "v": v, "w": w], actions: actions)
    }()
    
    // Statistics
    static let statistics: Algorithm = {
        let list = List(values: [Number(value: 1), Number(value: 2), Number(value: 3), Number(value: 4)])
        
        let actions: [Action] = [
            // Set default values
            SetAction("Σx", to: Number(value: 0)),
            SetAction("n", to: Number(value: 0)),
            
            // Iterate list
            ForAction("x", in: Variable(name: "L"), do: [
                SetAction("Σx", to: Sum(values: [Variable(name: "Σx"), Variable(name: "x")])),
                SetAction("n", to: TokenParser.init("n+1").execute())
            ]),
            
            // Last calculs
            SetAction("x̅", to: Fraction(numerator: Variable(name: "Σx"), denominator: Variable(name: "n"))),
            
            // Print values
            PrintAction("x̅"),
            PrintAction("Σx"),
            PrintAction("n")
        ]
        
        return Algorithm(name: "algo3_name".localized(), inputs: ["L": list], actions: actions)
    }()
    
    // Parse testing
    static let test: Algorithm = {
        let actions = AlgorithmParser("""
            print "λ"
            """).execute()
        
        return Algorithm(name: "Test", inputs: ["λ": Number(value: 0)], actions: actions)
    }()
    
}
