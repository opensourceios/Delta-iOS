//
//  StringExtension.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

extension String {

    // Localization
    
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }

    func format(_ args : CVarArg...) -> String {
        return String(format: self, locale: .current, arguments: args)
    }

    func format(_ args : [String]) -> String {
        return String(format: self, locale: .current, arguments: args)
    }
    
    // Operation
    
    func toOperation() -> Operation? {
        // Iterate values
        for value in [Operation.addition, Operation.subtraction, Operation.multiplication, Operation.division, Operation.power] {
            // If it's the value we want
            if self == value.toString() {
                return value
            }
        }
        
        // Nothing found
        return nil
    }
    
    func exponentize() -> String {
        // Define characters
        let supers = [
            "1": "\u{00B9}",
            "2": "\u{00B2}",
            "3": "\u{00B3}",
            "4": "\u{2074}",
            "5": "\u{2075}",
            "6": "\u{2076}",
            "7": "\u{2077}",
            "8": "\u{2078}",
            "9": "\u{2079}"
        ]

        // Final string and current char status
        var newStr = ""
        var isExp = false
        
        // Iterate string
        for char in self {
            // If exp character
            if char == "^" {
                // Clear space before
                if let last = newStr.last, last == " " {
                    newStr.removeLast()
                }
                
                // Set current as exp
                isExp = true
            } else {
                // If last was exp
                if isExp {
                    // Get character as string
                    let key = String(char)
                    
                    // Check if it's a numpber
                    if supers.keys.contains(key) {
                        // Replace by character
                        newStr.append(Character(supers[key]!))
                    } else if key != " " {
                        // End of number, go back to normal
                        isExp = false
                        newStr.append(char)
                    }
                } else {
                    // Normal state
                    newStr.append(char)
                }
            }
        }
        
        // Return final string
        return newStr
    }
    
    // Subscript
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, count) ..< count]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)), upper: min(count, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }

}
