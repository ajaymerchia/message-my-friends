//
//  Constants.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/2/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit
import iosManagers

class Constants {
    
}

class NotificationActions {
    // Actions
    
}



enum SignupError {
    case EmailInvalid
    case EmailInUse
    case EmailBlank
}

extension Notification.Name {
    static let dynamicLinkReceived = Notification.Name("dynamicLinkReceived")
    static let friendsReceived = Notification.Name("friendsReceived")
    
}

extension CGFloat {
    static let PADDING: CGFloat = 20
    static let MARGINAL_PADDING: CGFloat = 5
}

extension UIColor {
    static let DARK_BLUE = UIColor.colorWithRGB(rgbValue: 0x000c42)
    static let LIGHT_BLUE = UIColor.colorWithRGB(rgbValue: 0x5070ff)
    static let ACCENT_RED = UIColor.colorWithRGB(rgbValue: 0xe16040)
    static let ACCENT_GREEN = UIColor.colorWithRGB(rgbValue: 0x40e19b)
    static let ACCENT_BLUE = UIColor.colorWithRGB(rgbValue: 0x40c8e1)
    
    static let theme_orange   = UIColor.colorWithRGB(rgbValue: 0xff9700)
    static let theme_green    = UIColor.colorWithRGB(rgbValue: 0x2cd348)
    static let placeholder    = UIColor.colorWithRGB(rgbValue: 0xa8a8a8)
    
    static let offWhite = rgb(240,240,240)
    
    
}

extension UIImage {
    
    // Logo
    static let logo: UIImage! = UIImage(named: "logo-alpha")
    
    // Placeholders
    static let avatar: UIImage! = UIImage(named: "avatar-alpha")
    static let placeholder: UIImage! = UIImage(named: "white-placeholder")
    
    // Nav Icons
    static let nav_size = CGSize(width: 30, height: 30)
    static let nav_logout: UIImage! = UIImage(named: "nav-logout")!.resizeTo(nav_size)
    static let nav_refresh: UIImage! = UIImage(named: "nav-refresh")!.resizeTo(nav_size)
    
    // Icon Buttons
    static let mark_check: UIImage! = UIImage(named: "mark-check")
    static let mark_cancel: UIImage! = UIImage(named: "mark-cancel")

}

extension UIFont {
    static let title = UIFont(name: "Acier-DisplaySolid", size: 50)
    static let subtitle = UIFont(name: "Acier-DisplaySolid", size: 30)
    static let section = UIFont(name: "Acier-DisplaySolid", size: 24)
    static let header = UIFont(name: "Avenir-Heavy", size: 20)
    static let text = UIFont(name: "Avenir-Heavy", size: 16)
    static let light = UIFont(name: "Avenir-Book", size: 14)
    
    public func withTraits(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    public var italic : UIFont {
        return withTraits(.traitItalic)
    }
    
    public var bold : UIFont {
        return withTraits(.traitBold)
    }
}
