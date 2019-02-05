//
//  AddFriendVC-tableview.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/3/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers

extension AddFriendVC: UITableViewDelegate, UITableViewDataSource {
    func provideHeightFor(indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabledata.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return provideHeightFor(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "person") as! PersonCell
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        let cellUser = self.tabledata[indexPath.row]
        // Initialize Cell
        cell.awakeFromNib()
        cell.initializeCellFrom(data: cellUser, size: CGSize(width: tableView.frame.width, height: provideHeightFor(indexPath: indexPath)))
        
        cell.selectionStyle = .default
        cell.status.text = ""
        cell.status.textColor = .placeholder
        if cellUser == self.user {
            cell.selectionStyle = .none
            cell.status.text = "me"
        } else if Array(self.user.friends.values).contains(cellUser) {
            cell.selectionStyle = .none
            cell.status.text = "friends"
        } else if cellUser == self.userToSend {
            cell.status.text = "selected"
            cell.status.textColor = .theme_green
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var illegals = Array(self.user.friends.values)
        illegals.append(self.user)
        
        let newSelect = tabledata[indexPath.row]
        let legal = !illegals.contains(newSelect)
        
        self.userToSend = legal ? newSelect : nil
        
        var refreshes = [indexPath]
        if let oldInd = self.currIndPath {
            refreshes.append(oldInd)
        }
        tableView.reloadRows(at: refreshes, with: .fade)
        
        doneButton.isEnabled = legal
        self.currIndPath = legal ? indexPath : nil

    }
    
    


}
