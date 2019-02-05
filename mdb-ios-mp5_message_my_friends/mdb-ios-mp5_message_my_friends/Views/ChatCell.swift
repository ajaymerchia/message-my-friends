//
//  ChatCell.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/4/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    var msgBackground: UIView!
    var msgLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initializeCellFrom(msg: Message, outbound: Bool, size: CGSize) {
        if outbound {
            msgBackground = UIView(frame: CGRect(x: size.width * 0.25 - .PADDING, y: .MARGINAL_PADDING/2, width: size.width * 0.75, height: size.height - (.MARGINAL_PADDING)))
            msgBackground.backgroundColor = .theme_green
            msgBackground.layer.cornerRadius = 15
            msgBackground.clipsToBounds = true
            
            
            contentView.addSubview(msgBackground)
            
            msgLabel = UILabel(frame: msgBackground.frame)
            msgLabel.frame = CGRect(x: msgBackground.frame.minX + .PADDING, y: msgBackground.frame.minY, width: msgBackground.frame.width - 2 * .PADDING, height: msgBackground.frame.height)
            
            msgLabel.font = UIFont.text
            msgLabel.text = msg.msg
            msgLabel.textColor = .white
            
            msgLabel.lineBreakMode = .byWordWrapping
            msgLabel.numberOfLines = 0
            msgLabel.textAlignment = .left
            msgLabel.sizeToFit()
            msgLabel.frame.origin = CGPoint(x: msgBackground.frame.maxX - (2 * .MARGINAL_PADDING + msgLabel.frame.width), y: msgBackground.frame.midY - msgLabel.frame.height/2)
            
            contentView.addSubview(msgLabel)
            let sidePadding: CGFloat = .PADDING * 0.75
            msgBackground.frame = CGRect(x: msgLabel.frame.minX - sidePadding, y: msgBackground.frame.minY, width: msgLabel.frame.width + 2 * sidePadding, height: msgBackground.frame.height)
            
            
        } else {
            msgBackground = UIView(frame: CGRect(x: .PADDING, y: .MARGINAL_PADDING/2, width: size.width * 0.75, height: size.height - (.MARGINAL_PADDING)))
            msgBackground.backgroundColor = .offWhite
            msgBackground.layer.cornerRadius = 15
            msgBackground.clipsToBounds = true
            
            
            contentView.addSubview(msgBackground)
            
            msgLabel = UILabel(frame: msgBackground.frame)
            msgLabel.frame = CGRect(x: msgBackground.frame.minX + .PADDING, y: msgBackground.frame.minY, width: msgBackground.frame.width - 2 * .PADDING, height: msgBackground.frame.height)
            
            msgLabel.font = UIFont.text
            msgLabel.text = msg.msg
            msgLabel.textColor = .black
            
            msgLabel.lineBreakMode = .byWordWrapping
            msgLabel.numberOfLines = 0
            msgLabel.textAlignment = .left
            msgLabel.sizeToFit()
            msgLabel.frame.origin = CGPoint(x: msgBackground.frame.minX + .MARGINAL_PADDING, y: msgBackground.frame.midY - msgLabel.frame.height/2)
            
            contentView.addSubview(msgLabel)
            let sidePadding: CGFloat = .PADDING * 0.75
            msgBackground.frame = CGRect(x: sidePadding, y: msgBackground.frame.minY, width: msgLabel.frame.width + 2 * sidePadding, height: msgBackground.frame.height)
            
        }
    }
    
    

}
