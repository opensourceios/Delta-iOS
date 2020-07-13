//
//  APISyncStatus.swift
//  Delta
//
//  Created by Nathan FALLET on 26/02/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

enum APISyncStatus {
    
    case local, synchro, checkingforupdate, downloading, uploading, failed
    
    func colorForText() -> UIColor {
        switch self {
        case .synchro:
            return .systemGreen
        case .checkingforupdate, .downloading, .uploading:
            return .systemOrange
        case .failed:
            return .systemRed
        default:
            return .systemGray
        }
    }
    
}
