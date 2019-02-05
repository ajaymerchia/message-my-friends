//
//  ChatVC-text.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/4/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers

extension ChatVC: UITextFieldDelegate {
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame!.origin.y
            
            let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0
            
            UIView.animate(withDuration: duration) {
                print(endFrameY)
                print(self.view.frame.height)
                self.composeBar.frame.origin = CGPoint(x: 0, y: endFrameY - self.textfieldOffset)
                self.chatView.frame.size = CGSize(width: self.initialTableviewFrame.width, height: self.initialTableviewFrame.height - (self.view.frame.height - endFrameY))
            }
            
        }
    }
        
    
    @objc func messageBoxTyped() {
        sendButton.isEnabled = (composeTextField.text != "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendTextMessage()
        return true
    }
    
    
    


}
