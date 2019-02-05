//
//  AnonPersonCell.swift
//  HidesNight
//
//  Created by Ajay Merchia on 12/24/18.
//  Copyright © 2018 Ajay Merchia. All rights reserved.
//

import UIKit
import iosManagers
import ChameleonFramework

class PersonCell: UITableViewCell {
    
    var profilePic: UIButton!
    var name: UILabel!
    var email: UILabel!
    var status: UILabel!
    
    var usr: User!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func initializeCellFrom(data: User, size: CGSize) {
        usr = data
        let number = ((abs(CGFloat(usr.uid.hashValue))/pow(2,63)) * 180 * 10).truncatingRemainder(dividingBy: 180)
        let initals: String = String(self.usr.fullname.split(separator: " ").map { (sub) -> Substring in return sub.prefix(1)}.reduce("", +).prefix(2))
        
        profilePic = UIButton(frame: CGRect(x: .PADDING, y: 2 * .MARGINAL_PADDING, width: size.height - 4 * .MARGINAL_PADDING, height: size.height - 4 * .MARGINAL_PADDING))
        
        profilePic.setTitleColor(.white, for: .normal)
        profilePic.titleLabel?.font = UIFont.header
        profilePic.imageView?.contentMode = .scaleAspectFill
        profilePic.layer.cornerRadius = profilePic.frame.width/2
        profilePic.clipsToBounds = true
        
        if let actualPhoto = self.usr.photo {
            profilePic.setBackgroundImage(actualPhoto, for: .normal)
        } else {
            profilePic.setBackgroundColor(color: UIColor.ACCENT_RED.modified(withAdditionalHue: number, additionalSaturation: 0, additionalBrightness: 0), forState: .normal)
            profilePic.setTitle(initals, for: .normal)
        }
        
        self.contentView.addSubview(profilePic)
        
        name = UILabel(frame: CGRect(x: profilePic.frame.maxX + .PADDING, y: profilePic.frame.minY, width: size.width/2, height: profilePic.frame.height))
        name.textColor = .theme_orange
        name.text = data.fullname
        name.font = .text
        self.contentView.addSubview(name)
        
//        email = UILabel(frame: LayoutManager.belowCentered(elementAbove: name, padding: -1.5 * .PADDING, width: name.frame.width, height: 20))
//        email.textColor = .black
//        email.font = .light
//        email.text = usr.email
//        self.contentView.addSubview(email)
        
        status = UILabel(frame: CGRect(x: name.frame.maxX + .PADDING, y: name.frame.minY, width: size.width - (name.frame.maxX + .PADDING*2), height: name.frame.height))
        status.textColor = .placeholder
        status.font = .text
        status.textAlignment = .right
        self.contentView.addSubview(status)
        
    }
    
}
