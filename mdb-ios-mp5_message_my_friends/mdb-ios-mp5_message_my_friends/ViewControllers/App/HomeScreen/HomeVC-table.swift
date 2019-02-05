//
//  HomeVC-table.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/4/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit
import iosManagers

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func provideHeightFor(indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.user.friends.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return provideHeightFor(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "person") as! PersonCell
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        let cellUser = self.user.sortedFriends[indexPath.row]
        // Initialize Cell
        cell.awakeFromNib()
        cell.initializeCellFrom(data: cellUser, size: CGSize(width: tableView.frame.width, height: provideHeightFor(indexPath: indexPath)))
        
        cell.selectionStyle = .default
        
        // Remove status label, add accessory buttons
        if self.user.friendStatuses[cellUser.uid] == "pending" {
            let buttonHeight: CGFloat = 30
            let buttonWidth: CGFloat = view.frame.width/5
            let confirmButton = UIButton(frame: CGRect(x: cell.status.frame.maxX - buttonWidth, y: cell.status.frame.midY - buttonHeight/2, width: buttonWidth, height: buttonHeight))
            
            confirmButton.tag = indexPath.row
            confirmButton.setBackgroundColor(color: .white, forState: .normal)
            confirmButton.setBackgroundColor(color: .theme_green, forState: .highlighted)
            confirmButton.setBackgroundColor(color: .theme_green, forState: .selected)
            confirmButton.setTitle("Add", for: .normal)
            confirmButton.setTitleColor(.theme_green, for: .normal)
            confirmButton.setTitleColor(.white, for: .highlighted)
            confirmButton.setTitleColor(.white, for: .selected)
            confirmButton.titleLabel?.font = .text
            
            confirmButton.addTarget(self, action: #selector(confirmFriends(_:)), for: .touchUpInside)
            confirmButton.layer.cornerRadius = 5
            confirmButton.clipsToBounds = true
            confirmButton.layer.borderColor = UIColor.theme_green.cgColor
            confirmButton.layer.borderWidth = 1
            cell.contentView.addSubview(confirmButton)
        } else {
            
            cell.status.text = self.user.friendStatuses[cellUser.uid]
            cell.status.adjustsFontSizeToFitWidth = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.isUserInteractionEnabled = false
        self.friendToChat = self.user.sortedFriends[indexPath.row]
        self.user.getChat(for: self.friendToChat) { (chat) in
            self.view.isUserInteractionEnabled = true
            self.chatToShow = chat
            tableView.deselectRow(at: indexPath, animated: true)
            self.performSegue(withIdentifier: "home2chat", sender: self)
        }
        
        
        
    }
    
    
    
    
}
