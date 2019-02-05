//
//  ChatVC-table.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/4/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers

extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func heightComputer(indexPath: IndexPath) -> CGFloat {
        
        let biggerInitFrame = CGRect(x: view.frame.width * 0.25 - .PADDING, y: 0, width: view.frame.width * 0.75, height: 100)
        
        var sampleLabel = UILabel(frame: CGRect(x: biggerInitFrame.minX + .PADDING, y: biggerInitFrame.minY, width: biggerInitFrame.width - 2 * .PADDING, height: biggerInitFrame.height))
        
        sampleLabel.font = .text
        sampleLabel.numberOfLines = 0
        sampleLabel.textAlignment = .left
        sampleLabel.text = self.messages[indexPath.row].msg
        sampleLabel.sizeToFit()
        
        return sampleLabel.frame.height + 20
        
//        let msg = self.messages[indexPath.row]
//        var numRows = CGFloat(ceil(Double(msg.msg.count) / 30))
//
//        return 20 + 20 * numRows
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightComputer(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell") as! ChatCell
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        cell.awakeFromNib()
        cell.selectionStyle = .none
        
        let currentMessage = self.messages[indexPath.row]
        cell.initializeCellFrom(msg: currentMessage, outbound: currentMessage.senderID == self.user.uid, size: CGSize(width: view.frame.width, height: heightComputer(indexPath: indexPath)))
        
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
    
    


}
