//
//  ConfigUserVC-logic.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/3/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers

extension ConfigUserVC {
    @objc func validConfig() -> Bool {
        guard self.selectedImage != nil else {
            return false
        }
        
        let first = firstNameField.text!
        guard first != "" else {
            return false
        }
        
        let last = lastNameField.text!
        guard last != "" else {
            return false
        }
        
        return true
    }
    
    @objc func checkForValidConfig() {
        doneButton.isEnabled = validConfig()
    }

    @objc func updateUser() {
        self.view.isUserInteractionEnabled = false
        hud = alerts.startProgressHud(withMsg: "Updating User")
        if !validConfig() {
            return
        }
        
        user.first = firstNameField.text
        user.last = lastNameField.text
        user.photo = self.selectedImage
        
        FirebaseAPI.upload(user: user, withPhoto: true) {
            self.alerts.triggerCallback()
        }
        
    }

}
