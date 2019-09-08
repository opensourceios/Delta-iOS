//
//  FeatureExtension.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

extension Feature {
    
    // Equation de degré 2
    static let secondDegreeEquation: Feature = {
        let a = Input(name: "a", expression: Number(value: 1)) // a
        let b = Input(name: "b", expression: Number(value: 7)) // b
        let c = Input(name: "c", expression: Number(value: 12)) // c
        
        let d = Intermediate(name: "d", expression: "b".power(2).minus(4.times("a").times("c"))) // Delta
        let e = Intermediate(name: "e", expression: (-1).times("b").divides(2.times("a"))) // Alpha
        let f = Intermediate(name: "f", expression: (-1).times("d").divides(4.times("a"))) // Beta
        let g = Intermediate(name: "g", expression: (-1).times("b").minus("d".power(1.divides(2))).divides(2.times("a"))) // x1
        let h = Intermediate(name: "h", expression: (-1).times("b").plus("d".power(1.divides(2))).divides(2.times("a"))) // x2
        
        let developed = Output(name: "Developed form:", expression: "a".times("x".power(2)).plus("b".times("x")).plus("c"), conditions: ["a".inequals(0)])
        let canonical = Output(name: "Canonical form:", expression: "a".times("x".minus("e").power(2)).plus("f"), conditions: ["a".inequals(0)])
        let delta = Output(name: "∆ =", expression: Variable(name: "d"), conditions: ["a".inequals(0)])
        let x0 = Output(name: "x0 =", expression: Variable(name: "e"), conditions: ["d".equals(0), "a".inequals(0)])
        let x1 = Output(name: "x1 =", expression: Variable(name: "g"), conditions: ["d".greaterThan(0), "a".inequals(0)])
        let x2 = Output(name: "x2 =", expression: Variable(name: "h"), conditions: ["d".greaterThan(0), "a".inequals(0)])
        let factorized1 = Output(name: "Factorized form:", expression: "x".minus("e").power(2), conditions: ["d".equals(0), "a".inequals(0)])
        let factorized2 = Output(name: "Factorized form:", expression: "x".minus("g").times("x".minus("h")), conditions: ["d".greaterThan(0), "a".inequals(0)])
        
        return Feature(name: "Second degree equation", inputs: [a, b, c], intermediates: [d, e, f, g, h], outputs: [developed, canonical, delta, x0, x1, x2, factorized1, factorized2])
    }()
    
}
