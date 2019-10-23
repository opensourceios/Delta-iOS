//
//  ActionSelectorTableViewCell.swift
//  Delta
//
//  Created by Nathan FALLET on 22/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import UIKit

class ActionSelectorTableViewCell: UITableViewCell {

    let bubble = UIView()
    let icon = UIImageView()
    let category = UILabel()
    let label = UILabel()
    var line: EditorLine?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(bubble)
        contentView.addSubview(icon)
        contentView.addSubview(category)
        contentView.addSubview(label)
        
        bubble.translatesAutoresizingMaskIntoConstraints = false
        bubble.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        bubble.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        bubble.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        bubble.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        bubble.layer.cornerRadius = 10
        bubble.layer.masksToBounds = true
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.centerYAnchor.constraint(equalTo: category.centerYAnchor).isActive = true
        icon.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 10).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        category.translatesAutoresizingMaskIntoConstraints = false
        category.topAnchor.constraint(equalTo: bubble.topAnchor, constant: 10).isActive = true
        category.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 8).isActive = true
        category.trailingAnchor.constraint(lessThanOrEqualTo: bubble.trailingAnchor, constant: -10).isActive = true
        category.font = .boldSystemFont(ofSize: 17)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: category.bottomAnchor, constant: 10).isActive = true
        label.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 10).isActive = true
        label.trailingAnchor.constraint(lessThanOrEqualTo: bubble.trailingAnchor, constant: -10).isActive = true
        label.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: -10).isActive = true
        
        if #available(iOS 13.0, *) {
            bubble.backgroundColor = .secondarySystemGroupedBackground
        } else {
            bubble.backgroundColor = .white
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func with(line: EditorLine) -> ActionSelectorTableViewCell {
        // Set editor line
        self.line = line
        
        // Update icon, category and label
        icon.image = UIImage(named: line.category.rawValue.capitalizeFirstLetter())
        category.text = "category_\(line.category.rawValue)".localized()
        label.text = line.format.format(line.values)
        
        return self
    }

}
