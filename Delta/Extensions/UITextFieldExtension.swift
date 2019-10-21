//
//  UITextFieldExtension.swift
//  Delta
//
//  Created by Nathan FALLET on 21/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func addPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 20))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
}
