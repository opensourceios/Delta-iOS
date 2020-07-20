//
//  Exported.swift
//  Delta
//
//  Created by Nathan FALLET on 20/07/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import Foundation

struct Exported: Codable {
    
    var json: String?
    var sql: String?
    
    var string: String {
        // Create a string
        var string = ""
        
        // Check for JSON data
        if let json = json {
            string += "# Account data as JSON\n\(json)\n\n"
        }
        
        // Check for SQL data
        if let sql = sql {
            string += "# Account data as SQL\n\(sql)\n\n"
        }
        
        // Return final string
        return string
    }
    
}
