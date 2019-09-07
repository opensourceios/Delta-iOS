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
        let a = Input(name: "a", expression: Number(value: 1))
        let b = Input(name: "b", expression: Number(value: 7))
        let c = Input(name: "c", expression: Number(value: 12))
        
        let d = Intermediate(name: "d", expression: "b".power(2).minus(4.times("a").times("c")))
        let e = Intermediate(name: "e", expression: (-1).times("b").divides(2.times("a")))
        let f = Intermediate(name: "f", expression: (-1).times("d").divides(4.times("a")))
        
        let developed = Output(name: "Developed form:", expression: "a".times("x".power(2)).plus("b".times("x")).plus("c"))
        let canonical = Output(name: "Canonical form:", expression: "a".times("x".minus("e").power(2)).plus("f"))
        let delta = Output(name: "∆ =", expression: Variable(name: "d"))
        let x1 = Output(name: "x1 =", expression: (-1).times("b").minus("d".power(1.divides(2))).divides(2.times("a")))
        let x2 = Output(name: "x2 =", expression: (-1).times("b").plus("d".power(1.divides(2))).divides(2.times("a")))
        
        return Feature(name: "Second degree equation", inputs: [a, b, c], intermediates: [d, e, f], outputs: [developed, canonical, delta, x1, x2])
    }()
    
}
