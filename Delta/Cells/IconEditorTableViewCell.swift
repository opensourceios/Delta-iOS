//
//  IconEditorTableViewCell.swift
//  Delta
//
//  Created by Nathan FALLET on 12/07/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

class IconEditorTableViewCell: UITableViewCell {

    let icon = UIImageView()
    let name = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(icon)
        contentView.addSubview(name)
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.centerYAnchor.constraint(equalTo: name.centerYAnchor).isActive = true
        icon.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 17).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 17).isActive = true
        icon.layer.masksToBounds = true
        icon.layer.cornerRadius = 3
        
        name.translatesAutoresizingMaskIntoConstraints = false
        name.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        name.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 8).isActive = true
        name.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        name.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func with(type: String, value: String, selected: Bool) -> IconEditorTableViewCell {
        self.name.text = value.capitalizeFirstLetter()
        self.icon.image = type == "icon" ? value.toIcon() : nil
        self.icon.backgroundColor = type == "color" ? value.toColor() : .river
        self.accessoryType = selected ? .checkmark : .none
        
        return self
    }

}
