//
//  HomeTableViewCell.swift
//  Delta
//
//  Created by Nathan FALLET on 23/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    let icon = UIImageView()
    let name = UILabel()
    let desc = UILabel()
    
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
        name.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 8).isActive = true
        name.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        
        desc.translatesAutoresizingMaskIntoConstraints = false
        desc.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 4).isActive = true
        desc.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 8).isActive = true
        desc.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        desc.bottomAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        desc.font = .systemFont(ofSize: 15)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func with(algorithm: Algorithm) -> HomeTableViewCell {
        self.name.text = algorithm.name
        self.desc.text = "status_\(algorithm.status)".localized()
        self.desc.textColor = algorithm.status.colorForText()
        self.icon.image = algorithm.icon.icon.toIcon()
        self.icon.backgroundColor = algorithm.icon.color.toColor()
        
        return self
    }
    
    func with(algorithm: APIAlgorithm) -> HomeTableViewCell {
        self.name.text = algorithm.name
        self.desc.text = algorithm.owner?.name
        self.desc.textColor = .systemGray
        self.icon.image = algorithm.icon?.icon.toIcon()
        self.icon.backgroundColor = algorithm.icon?.color.toColor()
        
        return self
    }
    
    func with(name: String, desc: String, icon: UIImage?) -> HomeTableViewCell {
        self.name.text = name
        self.desc.text = desc
        self.desc.textColor = .systemGray
        self.icon.image = icon
        self.icon.backgroundColor = .clear
        
        return self
    }

}
