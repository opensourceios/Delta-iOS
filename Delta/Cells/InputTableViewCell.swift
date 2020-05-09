//
//  InputTableViewCell.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import UIKit

class InputTableViewCell: UITableViewCell, UITextFieldDelegate, UIDropInteractionDelegate {

    let label = UILabel()
    let field = UITextField()
    var input: (String, String)?
    weak var delegate: InputChangedDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(label)
        contentView.addSubview(field)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        label.bottomAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.adjustsFontSizeToFitWidth = true
        
        field.translatesAutoresizingMaskIntoConstraints = false
        field.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        field.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 4).isActive = true
        field.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        field.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        field.setContentCompressionResistancePriority(.required, for: .horizontal)
        field.autocapitalizationType = .none
        field.returnKeyType = .done
        field.delegate = self
        field.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        if #available(iOS 11, *) {
            addInteraction(UIDropInteraction(delegate: self))
            pasteConfiguration = UIPasteConfiguration(forAccepting: NSString.self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func with(input: (String, String), delegate: InputChangedDelegate) -> InputTableViewCell {
        self.input = input
        self.delegate = delegate
        
        label.attributedText = "\(input.0) =".attributedMath()
        field.text = input.1
        
        return self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            field.becomeFirstResponder()
        }
    }
    
    @objc func editingChanged(_ sender: Any) {
        input?.1 = field.text ?? ""
        delegate?.inputChanged(input)
    }
    
    /*func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let cs = NSCharacterSet(charactersIn: TokenParser.input).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")

        return (string == filtered)
    }*/
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        field.endEditing(true)
        return false
    }
    
    @available(iOS 11, *)
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    @available(iOS 11, *)
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    @available(iOS 11, *)
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        for item in session.items {
            item.itemProvider.loadObject(ofClass: NSString.self) { object, _ in
                if let string = object as? NSString {
                    DispatchQueue.main.async {
                        self.field.insertText(string as String)
                    }
                }
            }
        }
    }
    
    @available(iOS 11, *)
    override func paste(itemProviders: [NSItemProvider]) {
        for itemProvider in itemProviders {
            itemProvider.loadObject(ofClass: NSString.self) { object, _ in
                if let string = object as? NSString {
                    DispatchQueue.main.async {
                        self.field.insertText(string as String)
                    }
                }
            }
        }
    }

}
