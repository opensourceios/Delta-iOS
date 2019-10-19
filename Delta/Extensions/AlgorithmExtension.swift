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
    static let secondDegreeEquation: Algorithm = {
        let a = Number(value: 1)
        let b = Number(value: 7)
        let c = Number(value: 12)
        
        let actions: [Action] = [
            // Check if a != 0
            IfAction("a".inequals(0), do: [
                // Set main values
                SetAction("Δ", to: Parser.init("b^2-4ac").execute()),
                SetAction("α", to: Parser.init("(-b)/(2a)").execute()),
                SetAction("β", to: Parser.init("(-Δ)/(4a)").execute()),
                
                // Developed form
                SetAction("f(x)", to: Parser.init("ax^2+bx+c").execute(), format: true),
                PrintAction("f(x)"),
                
                // Canonical form
                SetAction("f(x)", to: Parser.init("a(x-α)^2+β").execute(), format: true),
                PrintAction("f(x)"),
                
                // Delta
                PrintAction("Δ"),
                
                // If delta is zero
                IfAction("Δ".equals(0), do: [
                    // Print root
                    SetAction("x_0", to: Variable(name: "α")),
                    PrintAction("x_0"),
                    
                    // Factorized form
                    SetAction("f(x)", to: Parser.init("a(x-x_0)^2").execute(), format: true),
                    PrintAction("f(x)")
                ], else: [
                    // Print roots
                    SetAction("x_1", to: Parser.init("(-b-Δ^(1/2))/2a").execute()),
                    SetAction("x_2", to: Parser.init("(-b+Δ^(1/2))/2a").execute()),
                    PrintAction("x_1"),
                    PrintAction("x_2"),
                    
                    // Factorized form
                    SetAction("f(x)", to: Parser.init("a(x-x_1)(x-x_2)").execute(), format: true),
                    PrintAction("f(x)")
                ])
            ])
        ]
        
        return Algorithm(name: "algo1_name".localized(), inputs: ["a": a, "b": b, "c": c], actions: actions)
    }()
    
    // Vectors
    static let vectors: Algorithm = {
        let u = Vector(values: [Number(value: 1), Number(value: 2)])
        let v = Vector(values: [Number(value: 3), Number(value: 4)])
        let w = Parser.init("u+v").execute()
        
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
            ForEachAction(Variable(name: "L"), as: "x", do: [
                SetAction("Σx", to: Sum(values: [Variable(name: "Σx"), Variable(name: "x")])),
                SetAction("n", to: Parser.init("n+1").execute())
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
    static let test: Algorithm = Algorithm(name: "Test", inputs: ["λ": Number(value: 0)], actions: [PrintAction("λ")])
    
}
