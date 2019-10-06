//
//  AlgorithmExtension.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

extension Algorithm {
    
    // Array of all algorithmes
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
                SetAction("Δ", to: "b".power(2).minus(4.times("a").times("c"))),
                SetAction("α", to: (-1).times("b").divides(2.times("a"))),
                SetAction("β", to: (-1).times("Δ").divides(4.times("a"))),
                
                // Developed form
                SetAction("f(x)", to: "a".times("x".power(2)).plus("b".times("x")).plus("c")),
                PrintAction("f(x)"),
                
                // Canonical form
                SetAction("f(x)", to: "a".times("x".minus("α").power(2)).plus("β")),
                PrintAction("f(x)"),
                
                // Delta
                PrintAction("Δ"),
                
                // If delta is positive
                IfAction("Δ".greaterThan(0), do: [
                    // Print roots
                    SetAction("x1", to: (-1).times("b").minus("Δ".power(1.divides(2))).divides(2.times("a"))),
                    SetAction("x2", to: (-1).times("b").plus("Δ".power(1.divides(2))).divides(2.times("a"))),
                    PrintAction("x1"),
                    PrintAction("x2"),
                    
                    // Factorized form
                    SetAction("f(x)", to: "a".times("x".minus("x1")).times("x".minus("x2"))),
                    PrintAction("f(x)"),
                ]),
                
                // If delta is zero
                IfAction("Δ".equals(0), do: [
                    // Print root
                    SetAction("x0", to: Variable(name: "α")),
                    PrintAction("x0"),
                    
                    // Factorized form
                    SetAction("f(x)", to: "a".times("x".minus("x0").power(2))),
                    PrintAction("f(x)"),
                ])
            ])
        ]
        
        return Algorithm(name: "f1_name".localized(), inputs: ["a": a, "b": b, "c": c], actions: actions)
    }()
    
    /*
    // Vector
    static let vectors: Algorithm = {
        let u = Input(name: "u", expression: Vector(values: [Number(value: 1), Number(value: 2)])) // u
        let v = Input(name: "v", expression: Vector(values: [Number(value: 3), Number(value: 4)])) // v
        let w = Input(name: "w", expression: "u".plus("v")) // w
        
        let result = Output(name: "w =", expression: Variable(name: "w"))
        
        return Algorithm(name: "Vectors", inputs: [u, v, w], actions: [])
    }()
    
    // Parse testing
    static let test: Algorithm = {
        let a = Input(name: "a", expression: Number(value: 0))
        let result = Output(name: "a =", expression: Variable(name: "a"))
        
        return Algorithm(name: "Test", inputs: [a], actions: [])
    }()
    */
    
}
