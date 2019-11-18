//
//  Database.swift
//  Delta
//
//  Created by Nathan FALLET on 23/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation
import SQLite

class Database {
    
    // Static instance
    static let current = Database()
    
    // Properties
    private var db: Connection?
    let algorithms = Table("algorithms")
    let local_id = Expression<Int64>("local_id")
    let remote_id = Expression<Int64?>("remote_id")
    let name = Expression<String>("name")
    let lines = Expression<String>("lines")
    let owner = Expression<Bool>("owner")
    let last_update = Expression<Date>("last_update")
    
    // Initialize
    init() {
        do {
            // Get database path
            if let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
                // Connect to database
                db = try Connection("\(path)/delta-math-helper.sqlite3")
                
                // Initialize tables
                try db?.run(algorithms.create(ifNotExists: true) { table in
                    table.column(local_id, primaryKey: .autoincrement)
                    table.column(remote_id)
                    table.column(name)
                    table.column(lines)
                    table.column(owner)
                    table.column(last_update)
                })
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Get algorithms
    func getAlgorithms() -> [Algorithm] {
        // Initialize an array
        var list = [Algorithm]()
        
        do {
            // Get algorithms data
            if let result = try db?.prepare(algorithms.order(last_update.desc)) {
                // Iterate data
                for line in result {
                    // Create algorithm in list
                    list.append(AlgorithmParser(try line.get(local_id), remote_id: try line.get(remote_id), owned: try line.get(owner), named: try line.get(name), last_update: try line.get(last_update), with: try line.get(lines)).execute())
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        // Return found algorithms
        return list
    }
    
    // Add an algorithm into database
    func addAlgorithm(_ algorithm: Algorithm) -> Algorithm {
        do {
            // Update last update
            algorithm.last_update = Date()
            
            // Insert data
            let id = try db?.run(algorithms.insert(remote_id <- algorithm.remote_id, name <- algorithm.name, lines <- algorithm.toString(), owner <- algorithm.owner, last_update <- algorithm.last_update)) ?? 0
            
            // Update id
            algorithm.local_id = id
        } catch {
            print(error.localizedDescription)
        }
        
        // Return algorithm
        return algorithm
    }
    
    // Update an algorithm
    func updateAlgorithm(_ algorithm: Algorithm) -> Algorithm {
        do {
            // If id is 0
            if algorithm.local_id == 0 {
                // Insert the algorithm
                return addAlgorithm(algorithm)
            }
            
            // Get line
            let line = algorithms.filter(local_id == algorithm.local_id && owner == true)
            
            // Update last update
            algorithm.last_update = Date()
            
            // Update data
            try db?.run(line.update(remote_id <- algorithm.remote_id, name <- algorithm.name, lines <- algorithm.toString(), owner <- algorithm.owner, last_update <- algorithm.last_update))
        } catch {
            print(error.localizedDescription)
        }
        
        // Return algorithm
        return algorithm
    }
    
    // Delete an algorithm
    func deleteAlgorithm(_ algorithm: Algorithm)  {
        do {
            // If id is 0
            if algorithm.local_id == 0 {
                return
            }
            
            // Get line
            let line = algorithms.filter(local_id == algorithm.local_id)
            
            // Delete data
            try db?.run(line.delete())
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
