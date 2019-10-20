//
//  EditorTableViewCell.swift
//  Delta
//
//  Created by Nathan FALLET on 20/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import UIKit

class EditorTableViewCell: UITableViewCell {

    let bubble = UIView()
    let label = UILabel()
    var leadingConstraint: NSLayoutConstraint!
    var line: EditorLine?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(bubble)
        contentView.addSubview(label)
        
        bubble.translatesAutoresizingMaskIntoConstraints = false
        bubble.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        leadingConstraint = bubble.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor)
        leadingConstraint.isActive = true
        bubble.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        bubble.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        bubble.layer.cornerRadius = 10
        bubble.layer.masksToBounds = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: bubble.topAnchor, constant: 10).isActive = true
        label.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 10).isActive = true
        label.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -10).isActive = true
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
    
    func with(line: EditorLine) -> EditorTableViewCell {
        self.line = line
        label.attributedText = line.format.format(line.values).attributedMath()
        leadingConstraint.constant = CGFloat(line.indentation * 20)
        
        return self
    }

}
