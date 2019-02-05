//
//  FriendVC.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/2/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {

    var user: User!
    var friend: User!
    
    var chat: Chat!
    
    var navbar: UINavigationBar!
    var composeBar: UIView!
    
    let composeBarHeight:CGFloat = 70
    
    var composeTextField: UITextField!
    var sendButton: UIButton!
    
    var chatView: UITableView!
    var messages: [Message] {
        return Array(self.chat.messages.values).sorted()
    }
    
    var navbarBottom: CGFloat!
    var textfieldOffset: CGFloat!
    
    var initialTableviewFrame: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
        FirebaseAPI.listenForNew(chat: self.chat) { (msg) in
            if msg.senderID != self.user.uid && self.chatView.numberOfRows(inSection: 0) != self.messages.count {
                self.addMessage()
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
