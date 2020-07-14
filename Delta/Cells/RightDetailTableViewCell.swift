//
//  RightDetailTableViewCell.swift
//  Delta
//
//  Created by Nathan FALLET on 14/07/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

class RightDetailTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func with(left: String, right: String, accessory: UITableViewCell.AccessoryType = .none) -> RightDetailTableViewCell {
        textLabel?.text = left
        detailTextLabel?.text = right
        accessoryType = accessory
        
        return self
    }
    
}
