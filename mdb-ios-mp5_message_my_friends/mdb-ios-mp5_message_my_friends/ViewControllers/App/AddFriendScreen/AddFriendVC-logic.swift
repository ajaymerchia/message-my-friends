//
//  AddFriendVC-logic.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/3/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers
import JGProgressHUD

extension AddFriendVC {
    @objc func sendInvite() {
        FirebaseAPI.request(friend: self.userToSend, from: self.user) {
            self.exit()
        }
    }
    
    func fetchData() {
        hud = JGProgressHUD(style: .light)
        hud?.show(in: self.view, animated: true)
        self.view.isUserInteractionEnabled = false
        FirebaseAPI.getAllUser { (users) in
            self.hud?.dismiss()
            self.view.isUserInteractionEnabled = true
            self.tabledata = users
            self.initTableview()
        }
        
    }


}
