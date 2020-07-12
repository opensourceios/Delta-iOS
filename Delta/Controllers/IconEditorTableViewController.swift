//
//  IconEditorTableViewController.swift
//  Delta
//
//  Created by Nathan FALLET on 12/07/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

class IconEditorTableViewController: UITableViewController {
    
    let icon: AlgorithmIcon
    let completionHandler: (AlgorithmIcon) -> ()
    
    init(icon: AlgorithmIcon, completionHandler: @escaping (AlgorithmIcon) -> ()) {
        self.icon = AlgorithmIcon(icon: icon.icon, color: icon.color)
        self.completionHandler = completionHandler
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Navigation bar
        navigationItem.title = "icon_title".localized()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cancel".localized(), style: .plain, target: self, action: #selector(close(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "save".localized(), style: .plain, target: self, action: #selector(save(_:)))
        
        // Register cells
        tableView.register(IconEditorTableViewCell.self, forCellReuseIdentifier: "iconCell")
        
        // Make cells auto sizing
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    @objc func close(_ sender: UIBarButtonItem) {
        // Dismiss view controller
        dismiss(animated: true, completion: nil)
    }
    
    @objc func save(_ sender: UIBarButtonItem) {
        // Call completion handler with new icon
        completionHandler(icon)
        
        // Dismiss view controller
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "icon_image".localized() : "icon_color".localized()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? AlgorithmIcon.valuesIcon.count : AlgorithmIcon.valuesColor.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get information
        let type = indexPath.section == 0 ? "icon" : "color"
        let value = indexPath.section == 0 ? AlgorithmIcon.valuesIcon[indexPath.row] : AlgorithmIcon.valuesColor[indexPath.row]
        let selected = indexPath.section == 0 ? icon.icon == value : icon.color == value
        
        // Return a cell
        return (tableView.dequeueReusableCell(withIdentifier: "iconCell", for: indexPath) as! IconEditorTableViewCell).with(type: type, value: value, selected: selected)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Set to icon
        if indexPath.section == 0 {
            icon.icon = AlgorithmIcon.valuesIcon[indexPath.row]
        } else {
            icon.color = AlgorithmIcon.valuesColor[indexPath.row]
        }
        
        // Reload table view
        tableView.reloadData()
    }

}
