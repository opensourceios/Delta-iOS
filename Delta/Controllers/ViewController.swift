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
            
            expression.text = String.localizedStringWithFormat(developed, "\(ns(a, ri1: true))x²\(ns(b, ri1: true, fs: true))x\(ns(c, fs: true))")
            expression.text = expression.text! + "\n" +
                String.localizedStringWithFormat(canonical, "\(ns(a, ri1: true))(x\(ns(b/(2*a), fs: true)))²\(ns((-pow(b, 2)+4*a*c)/(4*a), fs: true))")
            
            let d = pow(b, 2)-(4*a*c)
            expression.text = expression.text! + "\n\n∆ = \(ns(d))"
            
            if d > 0 {
                let x1 = (-b-pow(d, 0.5))/(2*a)
                let x2 = (-b+pow(d, 0.5))/(2*a)
                expression.text = expression.text! + "\nx1 = \(ns(x1))\nx2 = \(ns(x2))\n" + String.localizedStringWithFormat(factorized, "\(ns(a, ri1: true))(x\(ns(-x1, fs: true)))(x\(ns(-x2, fs: true)))")
            } else if d == 0 {
                let x0 = -b/(2*a)
                expression.text = expression.text! + "\nx0 = \(ns(x0))\n" + factorized2
            } else {
                expression.text = expression.text! + "\n" + factorized3
            }
        } else {
            let first_degree = NSLocalizedString("first_degree", value:"a = 0, first degree problem!", comment:"First degree")
            expression.text = first_degree
        }
    }
    
    func ns(_ d: Double, ri1: Bool = false, fs: Bool = false) -> String {
        var s: String
        if d == 1 && ri1 == true {
            s = ""
        } else if d == -1 && ri1 == true {
            s = "-"
        } else if d != floor(d) {
            let r = rationalApproximationOf(x0: d)
            s = String(r.num)+"/"+String(r.den)
        }else{
            s = String(Int(d))
        }
        return (d.sign == .plus && fs ? "+" : "") + "\(s)";
    }
    
    typealias Rational = (num : Int, den : Int)
    
    func rationalApproximationOf(x0 : Double, withPrecision eps : Double = 1.0E-6) -> Rational {
        var x = x0
        var a = floor(x)
        var (h1, k1, h, k) = (1, 0, Int(a), 1)
        
        while x - a > eps * Double(k) * Double(k) {
            x = 1.0/(x - a)
            a = floor(x)
            (h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
        }
        return (h, k)
    }
    
}

