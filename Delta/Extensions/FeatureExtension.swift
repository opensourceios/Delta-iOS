//
//  FeatureExtension.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

extension Feature {
    
    static let secondDegreeEquation = Feature(name: "Second degree equation", inputs: [
        Input(name: "a", expression: Number(value: 1)),
        Input(name: "b", expression: Number(value: 7)),
        Input(name: "c", expression: Number(value: 12))
    ], outputs: [
        Output(name: "Developed form:", expression: Parser.parseExpression(tokens: "ax^2+bx+c"))
        //Output(name: "Canonical form:", expression: Parser.parseExpression(tokens: "a(x+b/2a)^2+(-b^2+4ac)/4a")),
        //Output(name: "∆ =", expression: Parser.parseExpression(tokens: "b*b-4*a*c")),
        //Output(name: "x1 =", expression: Parser.parseExpression(tokens: "b*b-4*a*c"))
    ])
    
}
