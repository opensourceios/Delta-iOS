//
//  ViewController.swift
//  Delta
//
//  Created by Nathan FALLET on 9/17/18.
//  Copyright © 2018 Nathan FALLET. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var a: UITextField!
    @IBOutlet weak var b: UITextField!
    @IBOutlet weak var c: UITextField!
    @IBOutlet weak var expression: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func update(_ sender: Any) {
        self.a.endEditing(true)
        self.b.endEditing(true)
        self.c.endEditing(true)
        guard let a: Double = Double(self.a.text!.replacingOccurrences(of: ",", with: ".")) else { return }
        guard let b: Double = Double(self.b.text!.replacingOccurrences(of: ",", with: ".")) else { return }
        guard let c: Double = Double(self.c.text!.replacingOccurrences(of: ",", with: ".")) else { return }
        if a != 0 {
            expression.text =
                "Forme développée : \(a)x²\(ns(b))x\(ns(c))"
            expression.text = expression.text! +
                "\nForme canonique : \(a)(x\(ns(b/(2*a))))²\(ns((-pow(b, 2)+4*a*c)/(4*a)))"
            let d = pow(b, 2)-(4*a*c)
            expression.text = expression.text! + "\n\n∆ = \(d)"
            if d > 0 {
                let x1 = (-b-pow(d, 0.5))/(2*a)
                let x2 = (-b+pow(d, 0.5))/(2*a)
                expression.text = expression.text! + "\nx1 = \(x1)\nx2 = \(x2)\nForme factorisée : \(a)(x\(ns(-x1)))(x\(ns(-x2)))"
            } else if d == 0 {
                let x0 = -b/(2*a)
                expression.text = expression.text! + "\nx0 = \(x0)\nForme factorisée comme forme canonique"
            } else {
                expression.text = expression.text! + "\nPas de racine\nPas de forme factorisée"
            }
        } else {
            expression.text = "a = 0, problème du premier degré !";
        }
    }
    
    func ns(_ d: Double) -> String {
        return (d.sign == .plus ? "+" : "") + "\(d)";
    }
    
}

