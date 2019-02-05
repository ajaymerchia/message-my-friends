//
//  LaunchScreen-logic.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/2/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers
import FirebaseAuth

extension LaunchVC {
    func checkForLogin() {
        if let firUser = Auth.auth().currentUser {
            
            FirebaseAPI.getUser(for: firUser.uid) { (usrOpt) in
                guard let usr = usrOpt else {
                    self.pendingUser = User(uid: firUser.uid, email: firUser.email!)
                    self.performSegue(withIdentifier: "launch2home", sender: self)
                    return
                }
                
                self.pendingUser = usr
                self.performSegue(withIdentifier: "launch2home", sender: self)
            }
            
        } else {
            self.performSegue(withIdentifier: "launch2login", sender: self)
        }
    }


}
