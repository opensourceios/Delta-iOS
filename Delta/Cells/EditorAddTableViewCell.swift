//
//  EditorAddTableViewCell.swift
//  Delta
//
//  Created by Nathan FALLET on 22/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import UIKit

class EditorAddTableViewCell: UITableViewCell {

    let button = UIButton()
    var leadingConstraint: NSLayoutConstraint!
    var line: EditorLine?
    var index: Int = 0
    weak var delegate: EditorLineChangedDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        leadingConstraint = button.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor)
        leadingConstraint.isActive = true
        button.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.setTitle("category_add".localized(), for: .normal)
        button.addTarget(self, action: #selector(addAction(_:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func with(line: EditorLine, delegate: EditorLineChangedDelegate, at index: Int) -> EditorAddTableViewCell {
        // Set editor line
        self.line = line
        self.delegate = delegate
        self.index = index
        
        // Update left space
        leadingConstraint.constant = CGFloat(line.indentation * 30)
        
        return self
    }
    
    @objc func addAction(_ sender: UIButton) {
        // If delegate is a view controller (and it has to)
        if let controller = delegate as? UIViewController {
            // Create selector controller
            let selector = ActionSelectionTableViewController() { action in
                // Pass action to delegate
                self.delegate?.editorLineAdded(action, at: self.index)
            }
            
            // Show selector
            controller.present(UINavigationController(rootViewController: selector), animated: true, completion: nil)
        }
    }

}
