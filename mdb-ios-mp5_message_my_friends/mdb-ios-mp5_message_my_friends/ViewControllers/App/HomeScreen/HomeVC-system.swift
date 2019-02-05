//
//  HomeVC-system.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/3/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers
import FirebaseDatabase

extension HomeVC {
    func setupManagers() {
//        alerts = AlertManager(view: self, stateRestoration: {
//
//        })
        startListeningForNewFriends()
        
        FirebaseAPI.userEavesdrop(on: self.user) {
            self.updateData()
        }
//        Database.database().reference().child("users").child(self.user.uid).child("statuses").observe(.childChanged) { (_) in
//            self.updateData()
//        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        checkForUserCompleteness()
        updateData()
    }

    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let configVC = segue.destination as? ConfigUserVC {
            configVC.user = self.user
        } else if let addVC = segue.destination as? AddFriendVC {
            addVC.user = self.user
        } else if let chatVC = segue.destination as? ChatVC {
            chatVC.user = self.user
            chatVC.friend = self.friendToChat
            chatVC.chat = self.chatToShow
        }
    }

    // Segue Out Functions
    @objc func logout() {
        FirebaseAPI.logout()
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    @objc func goToConfig() {
        self.performSegue(withIdentifier: "home2config", sender: self)
    }
    @objc func goToAdd() {
        self.performSegue(withIdentifier: "home2add", sender: self)
    }

}
