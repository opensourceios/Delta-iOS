//
//  InputTableViewCell.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import UIKit

class InputTableViewCell: UITableViewCell {

    var label: UILabel = UILabel()
    var input: UITextField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(label)
        contentView.addSubview(input)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        label.bottomAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.adjustsFontSizeToFitWidth = true
        
        input.translatesAutoresizingMaskIntoConstraints = false
        input.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        input.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 4).isActive = true
        input.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        input.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        input.setContentCompressionResistancePriority(.required, for: .horizontal)
        input.placeholder = "0"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func with(text: String, accessory: UITableViewCell.AccessoryType = .none) -> InputTableViewCell {
        label.text = text
        accessoryType = accessory
        
        return self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            input.becomeFirstResponder()
        }
    }

}
