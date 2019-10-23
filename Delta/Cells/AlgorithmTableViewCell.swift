//
//  AlgorithmTableViewCell.swift
//  Delta
//
//  Created by Nathan FALLET on 23/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import UIKit

class AlgorithmTableViewCell: UITableViewCell {

    var name = UILabel()
    var last_update = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
        
        contentView.addSubview(name)
        contentView.addSubview(last_update)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        name.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        name.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        name.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        name.adjustsFontSizeToFitWidth = true
        
        last_update.translatesAutoresizingMaskIntoConstraints = false
        last_update.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5).isActive = true
        last_update.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        last_update.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        last_update.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        last_update.adjustsFontSizeToFitWidth = true
        last_update.font = .systemFont(ofSize: 15)
        last_update.textColor = .gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func with(algorithm: Algorithm) -> AlgorithmTableViewCell {
        name.text = algorithm.name
        last_update.text = "last_update".localized().format(algorithm.last_update.toRenderedString())
        
        return self
    }

}
