//
//  Account.swift
//  Delta
//
//  Created by Nathan FALLET on 26/02/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import Foundation
import APIRequest
import Keychain

class Account: Codable {

    // Singleton instances
    static let keychain = Keychain()
    static let current = Account()

    // Account properties
    var access_token: String?
    var user: APIUser?
    
    // Login from keychain
    func login() {
        // Check token from keychain
        if let access_token = Account.keychain.value(forKey: "access_token") as? String {
            // Login to account
            Account.current.login(access_token: access_token) { status in
                // Check status
                print(status)
            }
        }
    }
    
    // Login with an access token
    func login(access_token: String, completionHandler: @escaping (APIResponseStatus) -> ()) {
        // Fetch api with token
        APIRequest("GET", path: "/auth/account.php").with(header: "access_token", value: access_token).execute(Account.self) { data, status in
            // Check response validity
            if let account = data, status == .ok {
                // Store token and user
                self.access_token = account.access_token
                self.user = account.user
            }
            
            // Call completion handler
            completionHandler(status)
        }
    }
    
    // Login with credentials
    func login(username: String, password: String, completionHandler: @escaping (APIResponseStatus) -> ()) {
        // Fetch api with credentials
        APIRequest("GET", path: "/auth/access_token.php").with(header: "username", value: username).with(header: "password", value: password).execute(Account.self) { data, status in
            // Check response validity
            if let account = data, status == .created {
                // Store token and user
                self.access_token = account.access_token
                self.user = account.user
            }
            
            // Call completion handler
            completionHandler(status)
        }
    }
    
    // Register
    func register(name: String, username: String, password: String, completionHandler: @escaping (APIResponseStatus) -> ()) {
        // Fetch api with data
        APIRequest("POST", path: "/auth/account.php").with(body: [
            "name": name,
            "username": username,
            "password": password
        ]).execute(Account.self) { data, status in
            // Check response validity
            if let account = data, status == .created {
                // Store token and user
                self.access_token = account.access_token
                self.user = account.user
            }
            
            // Call completion handler
            completionHandler(status)
        }
    }
    
    // Logout
    func logout(completionHandler: @escaping (APIResponseStatus) -> ()) {
        // Delete token from API
        APIRequest("DELETE", path: "/auth/access_token.php").execute([String: Bool].self) { data, status in
            // Check response validity
            if data != nil, status == .ok {
                // Clear from keychain
                let _ = Account.keychain.remove(forKey: "access_token")
            }
            
            // Call completion handler
            completionHandler(status)
        }
    }

}
