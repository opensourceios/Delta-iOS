//
//  SwitchTableViewCell.swift
//  Delta
//
//  Created by Nathan FALLET on 13/07/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    let label = UILabel()
    let element = UISwitch()
    var onChange: ((Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
        contentView.addSubview(element)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        label.adjustsFontSizeToFitWidth = true
        
        element.translatesAutoresizingMaskIntoConstraints = false
        element.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
        element.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8).isActive = true
        element.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        element.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func with(text: String, enabled: Bool?, onChange: @escaping (Bool) -> Void) -> SwitchTableViewCell {
        self.label.text = text
        self.element.isEnabled = enabled != nil
        self.element.isOn = enabled ?? false
        self.onChange = onChange
        
        return self
    }
    
    @objc func valueChanged(_ sender: UISwitch) {
        self.onChange?(sender.isOn)
    }

}
