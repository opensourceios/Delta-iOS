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
        for value in [Operation.addition, Operation.subtraction, Operation.multiplication, Operation.division] {
            // If it's the value we want
            if self == value.toString() {
                return value
            }
        }
        
        // Nothing found
        return nil
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
