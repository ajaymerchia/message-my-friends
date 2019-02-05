//
//  LaunchScreen-initUI.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/2/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers

extension LaunchVC {
    func initUI() {
        initImage()
        initTitle()
    }

    // UI Initialization Helpers
    func initImage() {
        logo = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.height/3, height: view.frame.height/3))
        logo.center = CGPoint(x: view.frame.width/2, y: view.frame.height/3)
        logo.image = UIImage.logo
        logo.alpha = 0
        
        view.addSubview(logo)
        
        
    }
    
    func initTitle() {
        gameTitle = UILabel(frame: LayoutManager.belowCentered(elementAbove: logo, padding: .PADDING, width: view.frame.width - 4 * .PADDING, height: 70))
        gameTitle.font = UIFont.title
        gameTitle.adjustsFontSizeToFitWidth = true
        gameTitle.alpha = 0
        
        // Colorize the Text
        let gameTitleString = "Message My Friends"
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: gameTitleString)
        attributedString.setColor(color: UIColor.theme_green, forText: "Message")
        attributedString.setColor(color: UIColor.theme_orange, forText: "Friends")
        gameTitle.attributedText = attributedString
        
        view.addSubview(gameTitle)
    }

    func fadeIn(completion: (()->())?) {
        UIView.animate(withDuration: 1, animations: {
            self.gameTitle.alpha = 1
            self.logo.alpha = 1
        }) { (b) in
            completion?()
        }
    }
    
}
