//
//  EditorTableViewCell.swift
//  Delta
//
//  Created by Nathan FALLET on 20/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import UIKit

class EditorTableViewCell: UITableViewCell, UITextFieldDelegate {

    let bubble = UIView()
    let scroll = CellScrollView()
    let icon = UIImageView()
    let delete = UIButton(type: .custom)
    let category = UILabel()
    let stack = UIStackView()
    var leadingConstraint: NSLayoutConstraint!
    var line: EditorLine?
    var index: Int = 0
    weak var delegate: EditorLineChangedDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(bubble)
        contentView.addSubview(icon)
        contentView.addSubview(delete)
        contentView.addSubview(category)
        contentView.addSubview(scroll)
        scroll.addSubview(stack)
        
        bubble.translatesAutoresizingMaskIntoConstraints = false
        bubble.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        leadingConstraint = bubble.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor)
        leadingConstraint.isActive = true
        bubble.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        bubble.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        bubble.layer.cornerRadius = 10
        bubble.layer.masksToBounds = true
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.centerYAnchor.constraint(equalTo: category.centerYAnchor).isActive = true
        icon.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 10).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        delete.translatesAutoresizingMaskIntoConstraints = false
        delete.centerYAnchor.constraint(equalTo: category.centerYAnchor).isActive = true
        delete.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -10).isActive = true
        delete.widthAnchor.constraint(equalToConstant: 25).isActive = true
        delete.heightAnchor.constraint(equalToConstant: 25).isActive = true
        delete.setTitle("✖", for: .normal)
        delete.addTarget(self, action: #selector(deleteButton(_:)), for: .touchUpInside)
        
        category.translatesAutoresizingMaskIntoConstraints = false
        category.topAnchor.constraint(equalTo: bubble.topAnchor, constant: 10).isActive = true
        category.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 6).isActive = true
        category.trailingAnchor.constraint(lessThanOrEqualTo: delete.leadingAnchor, constant: -6).isActive = true
        category.font = .boldSystemFont(ofSize: 17)
        
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.topAnchor.constraint(equalTo: category.bottomAnchor).isActive = true
        scroll.leadingAnchor.constraint(equalTo: bubble.leadingAnchor).isActive = true
        scroll.trailingAnchor.constraint(equalTo: bubble.trailingAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: bubble.bottomAnchor).isActive = true
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 10).isActive = true
        stack.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 10).isActive = true
        stack.trailingAnchor.constraint(lessThanOrEqualTo: scroll.trailingAnchor, constant: -10).isActive = true
        stack.bottomAnchor.constraint(equalTo: scroll.bottomAnchor, constant: -10).isActive = true
        stack.heightAnchor.constraint(equalTo: scroll.heightAnchor, constant: -20).isActive = true
        stack.axis = .horizontal
        stack.spacing = 6
        
        if #available(iOS 13.0, *) {
            bubble.backgroundColor = .secondarySystemGroupedBackground
        } else {
            bubble.backgroundColor = .white
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func with(line: EditorLine, delegate: EditorLineChangedDelegate, at index: Int) -> EditorTableViewCell {
        // Set editor line
        self.line = line
        self.delegate = delegate
        self.index = index
        
        // Clear previous views
        while let view = stack.arrangedSubviews.first {
            view.removeFromSuperview()
        }
        
        // Add parts to stackview
        var args = line.values
        var tag = 0
        for part in line.format.localized().cutEditorLine() {
            // Add current part to line
            if part == "%@" {
                let field = UITextField()
                field.autocapitalizationType = .none
                field.returnKeyType = .done
                field.tag = tag
                field.textAlignment = .center
                field.delegate = self
                field.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
                field.backgroundColor = .groupTableViewBackground
                field.addPadding()
                field.layer.cornerRadius = 5
                field.layer.masksToBounds = true
                
                if args.count > 0 {
                    field.text = args.removeFirst()
                }
                
                stack.addArrangedSubview(field)
                tag += 1
            } else {
                let label = UILabel()
                label.text = part.trimmingCharacters(in: CharacterSet(charactersIn: " "))
                label.textAlignment = .center
                stack.addArrangedSubview(label)
            }
        }
        
        // Update left space
        leadingConstraint.constant = CGFloat(line.indentation * 30)
        
        // Update icon and category
        icon.image = UIImage(named: line.category.rawValue.capitalizeFirstLetter())
        category.text = "category_\(line.category.rawValue)".localized()
        
        // Delete button
        delete.isHidden = !line.movable
        
        return self
    }
    
    @objc func editingChanged(_ sender: UITextField) {
        // Update editor
        line?.values[sender.tag] = sender.text ?? ""
        
        // Send it to delegate
        delegate?.editorLineChanged(line, at: index)
    }
    
    @objc func deleteButton(_ sender: UIButton) {
        // Send it to delegate
        delegate?.editorLineDeleted(line, at: index)
    }
    
    /*func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let cs = NSCharacterSet(charactersIn: TokenParser.input).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")

        return (string == filtered)
    }*/
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }

}
