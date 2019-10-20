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
    let stack = UIStackView()
    var leadingConstraint: NSLayoutConstraint!
    var line: EditorLine?
    weak var delegate: EditorLineChangedDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(bubble)
        contentView.addSubview(stack)
        
        bubble.translatesAutoresizingMaskIntoConstraints = false
        bubble.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        leadingConstraint = bubble.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor)
        leadingConstraint.isActive = true
        bubble.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        bubble.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        bubble.layer.cornerRadius = 10
        bubble.layer.masksToBounds = true
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: bubble.topAnchor, constant: 10).isActive = true
        stack.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 10).isActive = true
        stack.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -10).isActive = true
        stack.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: -10).isActive = true
        stack.axis = .vertical
        
        if #available(iOS 13.0, *) {
            bubble.backgroundColor = .secondarySystemGroupedBackground
        } else {
            bubble.backgroundColor = .white
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func with(line: EditorLine, delegate: EditorLineChangedDelegate) -> EditorTableViewCell {
        // Set editor line
        self.line = line
        self.delegate = delegate
        
        // Clear previous views
        while let view = stack.arrangedSubviews.first {
            view.removeFromSuperview()
        }
        
        // Add parts to stackview
        var args = line.values
        var tag = 0
        var currentStack: UIStackView?
        for part in line.format.cutEditorLine() {
            // Create a line if needed
            if currentStack == nil {
                currentStack = UIStackView()
                currentStack?.axis = .horizontal
                currentStack?.distribution = .fillEqually
            }
            
            // Add current part to line
            if part == "%@" {
                let field = UITextField()
                field.autocapitalizationType = .none
                field.returnKeyType = .done
                field.tag = tag
                field.textAlignment = .center
                field.delegate = self
                field.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
                
                if args.count > 0 {
                    field.text = args.removeFirst()
                }
                
                currentStack?.addArrangedSubview(field)
                tag += 1
            } else {
                let label = UILabel()
                label.text = part.trimmingCharacters(in: CharacterSet(charactersIn: " "))
                label.textAlignment = .center
                currentStack?.addArrangedSubview(label)
            }
            
            // If line is "full"
            if let fullStack = currentStack, part == "%@", fullStack.arrangedSubviews.count > 1 {
                stack.addArrangedSubview(fullStack)
                currentStack = nil
            }
        }
        
        // If a line left
        if let fullStack = currentStack {
            stack.addArrangedSubview(fullStack)
            currentStack = nil
        }
        
        // Update left space
        leadingConstraint.constant = CGFloat(line.indentation * 20)
        
        return self
    }
    
    @objc func editingChanged(_ sender: UITextField) {
        // Update editor
        line?.values[sender.tag] = sender.text ?? ""
        delegate?.editorLineChanged(line)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let cs = NSCharacterSet(charactersIn: Parser.input).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")

        return (string == filtered)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }

}
