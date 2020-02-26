//
//  AlgorithmTableViewCell.swift
//  Delta
//
//  Created by Nathan FALLET on 23/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import UIKit

class AlgorithmTableViewCell: UITableViewCell {

    var icon = UIImageView()
    var name = UILabel()
    var desc = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        
        contentView.addSubview(icon)
        contentView.addSubview(name)
        contentView.addSubview(desc)
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        icon.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        icon.bottomAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 44).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 44).isActive = true
        icon.layer.masksToBounds = true
        icon.layer.cornerRadius = 8
        
        name.translatesAutoresizingMaskIntoConstraints = false
        name.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        name.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10).isActive = true
        name.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        
        desc.translatesAutoresizingMaskIntoConstraints = false
        desc.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 4).isActive = true
        desc.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10).isActive = true
        desc.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        desc.bottomAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        desc.font = .systemFont(ofSize: 15)
        desc.textColor = .gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func with(algorithm: Algorithm) -> AlgorithmTableViewCell {
        name.text = algorithm.name
        desc.text = "last_update".localized().format(algorithm.last_update.toRenderedString())
        icon.image = algorithm.icon.getUIImage()
        icon.backgroundColor = algorithm.icon.color.toColor()
        
        return self
    }

}
