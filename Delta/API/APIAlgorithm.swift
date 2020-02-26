//
//  APIAlgorithm.swift
//  Delta
//
//  Created by Nathan FALLET on 26/02/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import Foundation

struct APIAlgorithm: Codable {
    
    var id: Int64?
    var name: String?
    var owner: APIUser?
    var last_update: String?
    var lines: String?
    var notes: String?
    var icon: AlgorithmIcon?
    
    func toAlgorithm() -> Algorithm {
        return AlgorithmParser(0, remote_id: id, owned: false, named: name ?? "new_algorithm".localized(), last_update: last_update?.toDate() ?? Date(), icon: icon ?? AlgorithmIcon(), with: lines).execute()
    }
    
    func saveToDatabase() -> Algorithm {
        // Parse algorithm from downloaded data
        let algorithm = toAlgorithm()
        
        // Check if algorithm is already in database
        let fromDatabase = Database.current.getAlgorithm(id_remote: id ?? -1)
        if let fromDatabase = fromDatabase {
            // If yes, set the local id
            algorithm.local_id = fromDatabase.local_id
        }
        
        // Update (or insert) this algorithm
        return Database.current.updateAlgorithm(algorithm)
    }
    
    func fetchMissingData(completionHandler: @escaping (APIAlgorithm?, APIResponseStatus) -> Void) {
        // Make a request to API
        APIRequest("GET", path: "/algorithm/algorithm.php").with(name: "id", value: id ?? 0).execute(APIAlgorithm.self, completionHandler: completionHandler)
    }
    
}
