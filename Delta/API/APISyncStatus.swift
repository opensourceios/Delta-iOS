//
//  APISyncStatus.swift
//  Delta
//
//  Created by Nathan FALLET on 26/02/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

enum APISyncStatus {
    
    case local, synchronized, checkingforupdate, downloading, failed
    
    func colorForText() -> UIColor {
        switch self {
        case .synchronized:
            return .systemGreen
        case .checkingforupdate, .downloading:
            return .systemOrange
        case .failed:
            return .systemRed
        default:
            return .systemGray
        }
    }
    
}
