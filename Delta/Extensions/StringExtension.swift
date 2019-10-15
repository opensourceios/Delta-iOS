//
//  StringExtension.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation
import UIKit

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
    
    func groups(for regexPattern: String) -> [[String]] {
        do {
            let text = self
            let regex = try NSRegularExpression(pattern: regexPattern)
            let matches = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
            return matches.map { match in
                return (0 ..< match.numberOfRanges).map {
                    let rangeBounds = match.range(at: $0)
                    guard let range = Range(rangeBounds, in: text) else {
                        return ""
                    }
                    return String(text[range])
                }
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    // Custom operations
    
    func equals(_ right: Int) -> Equation {
        return Equation(left: Variable(name: self), right: Number(value: right), operation: .equals)
    }
    
    func inequals(_ right: Int) -> Equation {
        return Equation(left: Variable(name: self), right: Number(value: right), operation: .inequals)
    }
    
    func greaterThan(_ right: Int) -> Equation {
        return Equation(left: Variable(name: self), right: Number(value: right), operation: .greaterThan)
    }
    
    func lessThan(_ right: Int) -> Equation {
        return Equation(left: Variable(name: self), right: Number(value: right), operation: .lessThan)
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
    
    func attributedMath() -> NSAttributedString {
        let workspace = NSMutableAttributedString(string: self)
        let power: [NSAttributedString.Key: Any] = [.font:UIFont.systemFont(ofSize: 10),.baselineOffset:8]
        let index: [NSAttributedString.Key: Any] = [.font:UIFont.systemFont(ofSize: 10),.baselineOffset:-5]
        
        // Powers (numbers)
        let numbers = String(workspace.mutableString).groups(for: " \\^ [0-9]+")
        for group in numbers {
            let range = workspace.mutableString.range(of: group[0])
            workspace.addAttributes(power, range: range)
            workspace.replaceCharacters(in: range, with: group[0][3 ..< group[0].count])
        }
        
        // Powers (expressions)
        let expressions = String(workspace.mutableString).groups(for: " \\^ \\([0-9a-z*\\+\\-/ ]+\\)")
        for group in expressions {
            let range = workspace.mutableString.range(of: group[0])
            workspace.addAttributes(power, range: range)
            workspace.replaceCharacters(in: range, with: group[0][4 ..< group[0].count-1])
        }
        
        // Indexes
        let variables = String(workspace.mutableString).groups(for: "_[0-9a-z]")
        for group in variables {
            let range = workspace.mutableString.range(of: group[0])
            workspace.addAttributes(index, range: range)
            workspace.replaceCharacters(in: range, with: group[0][1 ..< group[0].count])
        }
        
        return workspace
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
