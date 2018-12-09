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
            let developed = NSLocalizedString("developed", value:"Developed form: %@", comment:"Developed form")
            let canonical = NSLocalizedString("canonical", value:"Canonical form: %@", comment:"Canonical form")
            let factorized = NSLocalizedString("factorized", value:"Factorized form: %@", comment:"Factorized form")
            let factorized2 = NSLocalizedString("factorized2", value:"Factorized form like canonical", comment:"Factorized form like canonical")
            let factorized3 = NSLocalizedString("factorized3", value:"No roots\nNo factorized form", comment:"No roots - No factorized form")
            
            expression.text = String.localizedStringWithFormat(developed, "\(a)x²\(ns(b))x\(ns(c))")
            expression.text = expression.text! + "\n" +
                String.localizedStringWithFormat(canonical, "\(a)(x\(ns(b/(2*a))))²\(ns((-pow(b, 2)+4*a*c)/(4*a)))")
            
            let d = pow(b, 2)-(4*a*c)
            expression.text = expression.text! + "\n\n∆ = \(d)"
            
            if d > 0 {
                let x1 = (-b-pow(d, 0.5))/(2*a)
                let x2 = (-b+pow(d, 0.5))/(2*a)
                expression.text = expression.text! + "\nx1 = \(x1)\nx2 = \(x2)\n" + String.localizedStringWithFormat(factorized, "\(a)(x\(ns(-x1)))(x\(ns(-x2)))")
            } else if d == 0 {
                let x0 = -b/(2*a)
                expression.text = expression.text! + "\nx0 = \(x0)\n" + factorized2
            } else {
                expression.text = expression.text! + "\n" + factorized3
            }
        } else {
            let first_degree = NSLocalizedString("first_degree", value:"a = 0, first degree problem!", comment:"First degree")
            expression.text = first_degree
        }
    }
    
    func ns(_ d: Double) -> String {
        return (d.sign == .plus ? "+" : "") + "\(d)";
    }
    
}

