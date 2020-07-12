//
//  LoadingTableViewCell.swift
//  Delta
//
//  Created by Nathan FALLET on 12/07/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {

    let activityIndicator = UIActivityIndicatorView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func with() -> LoadingTableViewCell {
        activityIndicator.startAnimating()
        return self
    }

}
