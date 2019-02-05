//
//  LoginVC-initUI.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/2/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers
import ChameleonFramework

extension LoginVC {
    func initUI() {
        initImage()
        initTitle()
        
        initField()
            addValidators()
        initLogin()
        
        addKeyboardDismiss()
        
    }
    
    // UI Initialization Helpers
    func initImage() {
        logo = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.height/3, height: view.frame.height/3))
        logo.center = CGPoint(x: view.frame.width/2, y: view.frame.height/3)
        logo.image = UIImage.logo

        
        view.addSubview(logo)
        
        
    }
    
    func initTitle() {
        gameTitle = UILabel(frame: LayoutManager.belowCentered(elementAbove: logo, padding: .PADDING, width: view.frame.width - 4 * .PADDING, height: 70))
        gameTitle.font = UIFont.title
        gameTitle.adjustsFontSizeToFitWidth = true
        
        // Colorize the Text
        let gameTitleString = "Message My Friends"
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: gameTitleString)
        attributedString.setColor(color: UIColor.theme_green, forText: "Message")
        attributedString.setColor(color: UIColor.theme_orange, forText: "Friends")
        gameTitle.attributedText = attributedString
        
        view.addSubview(gameTitle)
    }

    func initField() {
        emailField = LabeledTextField(frame: LayoutManager.belowCentered(elementAbove: gameTitle, padding: .PADDING, width: gameTitle.frame.width, height: 60))
        emailField.placeholder = "Email address"
        
        emailField.keyboardType = .emailAddress
        emailField.textAlignment = .center
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.font = UIFont.header
        
        emailField.tintColor = .theme_orange
        emailField.textColor = .theme_orange
        emailField.lineColor = UIColor.flatGray
        emailField.selectedLineColor = .theme_orange
        
        emailField.titleColor = .black
        emailField.selectedTitleColor = .theme_orange
        
        emailField.errorColor = .ACCENT_RED
        
        emailField.returnKeyType = .go
        emailField.alpha = 0
        
        
        view.addSubview(emailField)
    }
    
    func initLogin() {
        login = UIButton(frame: LayoutManager.belowCentered(elementAbove: self.emailField, padding: .PADDING, width: view.frame.width/3, height: 40))
        login.titleLabel?.font = UIFont.header
        login.alpha = 0
        login.setTitleColor(UIColor.theme_green, for: .normal)
        login.setTitle("Login/Signup", for: .normal)
        login.addTarget(self, action: #selector(sendLoginEmail), for: .touchUpInside)
        
        view.addSubview(login)
    }
    
    
    
    
    
    
    
    func fadeIn(completion: @escaping (()->()) = {}) {
        UIView.animate(withDuration: 1, animations: {
            self.emailField.alpha = 1
            self.login.alpha = 1
        }) { (b) in
            completion()
        }
    }
    
    func addKeyboardDismiss() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        self.emailField.resignFirstResponder()
    }
    
    
}
