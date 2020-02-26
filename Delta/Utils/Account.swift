//
//  Account.swift
//  Delta
//
//  Created by Nathan FALLET on 26/02/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import Foundation

class Account: Codable {

    static var current: Account = Account()

    var access_token: String?

}
