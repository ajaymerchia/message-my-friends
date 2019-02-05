//
//  ChatVC-initUI.swift
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
    func initUI() {
        initNav()
        
        navbarBottom = self.navigationController?.navigationBar.frame.height
        textfieldOffset = (composeBarHeight)
        
        initInputControl()
        initTableview()
        keyboardRehandling()
    }

    // UI Initialization Helpers
    func initNav() {
        self.title = self.friend.first
    }
    
    func initInputControl() {
        let inset: CGFloat = 4
        
        composeBar = UIView(frame: CGRect(x: 0, y: view.frame.maxY - textfieldOffset, width: view.frame.width, height: composeBarHeight))
        composeBar.backgroundColor = .white
        
        
        let verticalIndent: CGFloat = .PADDING
        let itemHeight: CGFloat = composeBarHeight - 2 * verticalIndent
        
        let sendButtonWidth: CGFloat = 70
        sendButton = UIButton(frame: CGRect(x: view.frame.width - (sendButtonWidth + .PADDING), y: 0, width: sendButtonWidth, height: composeBar.frame.height))
        sendButton.setTitle("Send", for: .normal)
        sendButton.titleLabel?.font = UIFont.text
        sendButton.setTitleColor(.placeholder, for: .disabled)
        sendButton.setTitleColor(UIColor.theme_green, for: .normal)
        sendButton.isEnabled = false
        sendButton.addTarget(self, action: #selector(sendTextMessage), for: .touchUpInside)
        
        composeTextField = UITextField(frame: CGRect(x: .PADDING, y: verticalIndent, width: (sendButton.frame.minX - 3 * .MARGINAL_PADDING), height: itemHeight))
        
        composeTextField.attributedPlaceholder = NSAttributedString(string: "Aa", attributes: [NSAttributedString.Key.foregroundColor : UIColor.placeholder, NSAttributedString.Key.font: UIFont.text!])
        composeTextField.font = .text
        composeTextField.textColor = .black
        composeTextField.tintColor = .theme_green
        composeTextField.backgroundColor = .offWhite
        composeTextField.layer.cornerRadius = composeTextField.frame.height/2
        composeTextField.delegate = self
        composeTextField.returnKeyType = .send
        composeTextField.addTarget(self, action: #selector(messageBoxTyped), for: .allEditingEvents)
        
        
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        composeTextField.leftViewMode = .always
        composeTextField.leftView = spacerView
        
        let topBorder = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1))
        topBorder.backgroundColor = .theme_green
        composeBar.addSubview(topBorder)
        
        composeBar.addSubview(composeTextField)
        composeBar.addSubview(sendButton)
        view.addSubview(composeBar)
    }
    
    func initTableview() {
//        chatView = UITableView(frame: CGRect(x: 0, y: navigationController!.navigationBar.frame.maxY, width: view.frame.width, height: composeBar.frame.minY - navigationController!.navigationBar.frame.maxY))
        chatView = UITableView(frame: LayoutManager.between(elementAbove: self.navigationController!.navigationBar, elementBelow: self.composeBar, width: view.frame.width, topPadding: 0, bottomPadding: .MARGINAL_PADDING*2))
        self.initialTableviewFrame = chatView.frame
        chatView.separatorStyle = .none
        chatView.keyboardDismissMode = .interactive
        chatView.register(ChatCell.self, forCellReuseIdentifier: "chatCell")
        chatView.dataSource = self
        chatView.delegate = self
        chatView.indicatorStyle = .black
        
        chatView.transform = CGAffineTransform(scaleX: 1, y: -1)

        
        view.addSubview(chatView)
        view.sendSubviewToBack(chatView)
    }
    
    
    func keyboardRehandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    

}
