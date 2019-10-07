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
        .secondDegreeEquation,
        .vectors,
        .statistics
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
                    SetAction("x1", to: (-1).times("b").minus("Δ".sqrt()).divides(2.times("a"))),
                    SetAction("x2", to: (-1).times("b").plus("Δ".sqrt()).divides(2.times("a"))),
                    PrintAction("x1"),
                    PrintAction("x2"),
                    
                    // Factorized form
                    SetAction("f(x)", to: "a".times("x".minus("x1")).times("x".minus("x2"))),
                    PrintAction("f(x)")
                ]),
                
                // If delta is zero
                IfAction("Δ".equals(0), do: [
                    // Print root
                    SetAction("x0", to: Variable(name: "α")),
                    PrintAction("x0"),
                    
                    // Factorized form
                    SetAction("f(x)", to: "a".times("x".minus("x0").power(2))),
                    PrintAction("f(x)")
                ]),
                
                // If delta is negative
                IfAction("Δ".lessThan(0), do: [
                    // Print roots
                    SetAction("x1", to: (-1).times("b").minus("i".times((-1).times("Δ").sqrt())).divides(2.times("a"))),
                    SetAction("x2", to: (-1).times("b").plus("i".times((-1).times("Δ").sqrt())).divides(2.times("a"))),
                    PrintAction("x1"),
                    PrintAction("x2"),
                    
                    // Factorized form
                    SetAction("f(x)", to: "a".times("x".minus("x1")).times("x".minus("x2"))),
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
        let w = "u".plus("v")
        
        let actions: [Action] = [
            PrintAction("w")
        ]
        
        return Algorithm(name: "algo2_name".localized(), inputs: ["u": u, "v": v, "w": w], actions: actions)
    }()
    
    // Statistics
    static let statistics: Algorithm = {
        let list = List(values: [Number(value: 1), Number(value: 2), Number(value: 3), Number(value: 4)])
        
        let actions: [Action] = [
            
        ]
        
        return Algorithm(name: "", inputs: ["L": list], actions: actions)
    }()
    
    /*
    // Parse testing
    static let test: Algorithm = {
        let a = Input(name: "a", expression: Number(value: 0))
        let result = Output(name: "a =", expression: Variable(name: "a"))
        
        return Algorithm(name: "Test", inputs: [a], actions: [])
    }()
    */
    
}
