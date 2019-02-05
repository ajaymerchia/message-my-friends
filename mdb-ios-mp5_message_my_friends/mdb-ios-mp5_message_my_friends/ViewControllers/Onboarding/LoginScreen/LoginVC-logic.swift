//
//  LoginVC-logic.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/2/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers

extension LoginVC {
    func addValidators() {
        emailField.addTarget(self, action: #selector(emailValidatorProxy), for: .editingChanged)
        emailField.addTarget(self, action: #selector(sendLoginEmail), for: .editingDidEndOnExit)
    }
    
    @objc func emailValidatorProxy() { _ = emailValidator() }
    
    
    func emailValidator() -> SignupError? {
        guard let text = emailField.text else {
            emailField.errorMessage = ""
            return .EmailBlank
        }
        if text == "" {
            emailField.errorMessage = ""
            return .EmailBlank
        } else if !text.contains("@") || !text.contains(".") || text.contains(" ") || text.count < 3 {
            emailField.errorMessage = "Invalid Email"
            return .EmailInvalid
        }
        
        emailField.errorMessage = ""
        return nil
    }
    
    @objc func sendLoginEmail() {
        guard let email = emailField.getText() else {
            emailField.shake()
            return
        }
        
        if emailValidator() != nil {
            emailField.shake()
            return
        }
        
        self.view.isUserInteractionEnabled = false
        dismissKeyboard()
        hud = alerts.startProgressHud(withMsg: "Sending login email")
        FirebaseAPI.sendLoginEmail(to: email) { (msg, success) in
            debugPrint(success)
            debugPrint(msg)
            LocalData.putLocalData(forKey: .email, data: email)
            self.alerts.triggerCallback()
        }
        
    }
    
    @objc func performLogin(_ notification: Notification) {
        guard let link = notification.userInfo?["link"] as? String else {
            return
        }
        
        performLogin(link: link)
        
    }
    
    func performLogin(link: String) {
        guard let email = LocalData.getLocalData(forKey: .email) else {
            return
        }
        
        FirebaseAPI.login(email: email, link: link) { usr in
            guard let newUser = usr else {
                debugPrint("failed to login")
                return
            }
            
            self.user = newUser
            FirebaseAPI.getUser(for: newUser.uid, completion: { (userOpt) in
                if let loadedUser = userOpt {
                    self.user = loadedUser
                }
                debugPrint("loggedIn")
                self.performSegue(withIdentifier: "login2home", sender: self)
            })
            
            
            
        }
        
    }
    
    


}
