//
//  WelcomeViewController.swift
//  Delta
//
//  Created by Nathan FALLET on 11/06/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let header1 = UILabel()
    let paragraph1 = UILabel()
    let image1 = UIImageView()
    let header2 = UILabel()
    let paragraph2 = UILabel()
    let image2 = UIImageView()
    let header3 = UILabel()
    let paragraph3 = UILabel()
    let image3 = UIImageView()
    let header4 = UILabel()
    let button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        navigationController?.navigationBar.barStyle = .black
        
        title = "welcome_title".localized()
        
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        contentView.addSubview(header1)
        contentView.addSubview(paragraph1)
        contentView.addSubview(image1)
        contentView.addSubview(header2)
        contentView.addSubview(paragraph2)
        contentView.addSubview(image2)
        contentView.addSubview(header3)
        contentView.addSubview(paragraph3)
        contentView.addSubview(image3)
        contentView.addSubview(header4)
        contentView.addSubview(button)
        
        header1.translatesAutoresizingMaskIntoConstraints = false
        header1.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        header1.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        header1.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        header1.font = .boldSystemFont(ofSize: 20)
        header1.text = "welcome_header1".localized()
        header1.textColor = .white
        header1.numberOfLines = 0
        
        paragraph1.translatesAutoresizingMaskIntoConstraints = false
        paragraph1.topAnchor.constraint(equalTo: header1.bottomAnchor, constant: 8).isActive = true
        paragraph1.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        paragraph1.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        paragraph1.text = "welcome_paragraph1".localized()
        paragraph1.textColor = .white
        paragraph1.numberOfLines = 0
        
        image1.translatesAutoresizingMaskIntoConstraints = false
        image1.topAnchor.constraint(equalTo: paragraph1.bottomAnchor, constant: 8).isActive = true
        image1.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        image1.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        image1.image = UIImage(named: "Welcome1")
        image1.contentMode = .center
        
        header2.translatesAutoresizingMaskIntoConstraints = false
        header2.topAnchor.constraint(equalTo: image1.bottomAnchor, constant: 16).isActive = true
        header2.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        header2.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        header2.font = .boldSystemFont(ofSize: 20)
        header2.text = "welcome_header2".localized()
        header2.textColor = .white
        header2.numberOfLines = 0
        
        paragraph2.translatesAutoresizingMaskIntoConstraints = false
        paragraph2.topAnchor.constraint(equalTo: header2.bottomAnchor, constant: 8).isActive = true
        paragraph2.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        paragraph2.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        paragraph2.text = "welcome_paragraph2".localized()
        paragraph2.textColor = .white
        paragraph2.numberOfLines = 0
        
        image2.translatesAutoresizingMaskIntoConstraints = false
        image2.topAnchor.constraint(equalTo: paragraph2.bottomAnchor, constant: 8).isActive = true
        image2.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        image2.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        image2.image = UIImage(named: "Welcome2")
        image2.contentMode = .center
        
        header3.translatesAutoresizingMaskIntoConstraints = false
        header3.topAnchor.constraint(equalTo: image2.bottomAnchor, constant: 16).isActive = true
        header3.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        header3.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        header3.font = .boldSystemFont(ofSize: 20)
        header3.text = "welcome_header3".localized()
        header3.textColor = .white
        header3.numberOfLines = 0
        
        paragraph3.translatesAutoresizingMaskIntoConstraints = false
        paragraph3.topAnchor.constraint(equalTo: header3.bottomAnchor, constant: 8).isActive = true
        paragraph3.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        paragraph3.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        paragraph3.text = "welcome_paragraph3".localized()
        paragraph3.textColor = .white
        paragraph3.numberOfLines = 0
        
        image3.translatesAutoresizingMaskIntoConstraints = false
        image3.topAnchor.constraint(equalTo: paragraph3.bottomAnchor, constant: 8).isActive = true
        image3.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        image3.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        image3.image = UIImage(named: "Welcome3")
        image3.contentMode = .center
        
        header4.translatesAutoresizingMaskIntoConstraints = false
        header4.topAnchor.constraint(equalTo: image3.bottomAnchor, constant: 16).isActive = true
        header4.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        header4.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        header4.font = .boldSystemFont(ofSize: 20)
        header4.text = "welcome_header4".localized()
        header4.textColor = .white
        header4.numberOfLines = 0
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: header4.bottomAnchor, constant: 8).isActive = true
        button.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.setTitle("welcome_button".localized(), for: .normal)
        button.addTarget(self, action: #selector(close(_:)), for: .touchUpInside)
    }
    
    @objc func close(_ sender: UIBarButtonItem) {
        // Save welcome shown
        let datas = UserDefaults.standard
        datas.set(true, forKey: "welcomeShown")
        datas.synchronize()
        
        // Dismiss view controller
        dismiss(animated: true, completion: nil)
    }

}
