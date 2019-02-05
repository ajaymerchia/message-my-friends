//
//  ChatVC-logic.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/4/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers

extension ChatVC {
    @objc func sendTextMessage() {
//        if needsRefresh() {
//            self.chatView.reloadData()
//        }
        composeTextField.becomeFirstResponder()
        self.sendButton.isEnabled = false
        guard let msg = composeTextField.text else { return }
        self.composeTextField.text = ""
        
        if msg == "" {
            return
        }
        
        let textMessage = Message(msg: msg, sender: self.user)

        FirebaseAPI.send(msg: textMessage, to: self.chat) {
            debugPrint("messageSent")
        }
        
        
        addMessage()
        
        
    }
    
    func addMessage() {
        self.chatView.beginUpdates()
        self.chatView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        self.chatView.endUpdates()
    }


}
