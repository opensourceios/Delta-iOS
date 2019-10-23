//
//  OutputTableViewCell.swift
//  Delta
//
//  Created by Nathan FALLET on 19/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import UIKit

class OutputTableViewCell: UITableViewCell, UIDragInteractionDelegate {
    
    var originalOutput: String?
    var label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        label.adjustsFontSizeToFitWidth = true
        
        if #available(iOS 11.0, *) {
            addInteraction(UIDragInteraction(delegate: self))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func with(text: String) -> OutputTableViewCell {
        originalOutput = text
        label.attributedText = text.attributedMath()
        
        return self
    }
    
    @available(iOS 11.0, *)
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        let itemProvider = NSItemProvider(object: (originalOutput ?? "") as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
    }

}
