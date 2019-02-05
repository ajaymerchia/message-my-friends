//
//  AddFriend-initUI.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/3/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers

extension AddFriendVC {
    func initUI() {
        initNav()
    }

    // UI Initialization Helpers
    func initNav() {
        
        navbar = UINavigationBar(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.maxY, width: view.frame.width, height: 40))
        
        let item = UINavigationItem()
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(sendInvite))
        doneButton.isEnabled = false
        doneButton.tintColor = .theme_orange
        item.rightBarButtonItem = doneButton
        item.title = "Add a Friend"
        
        let leftButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(exit))
        leftButton.tintColor = .theme_orange
        item.leftBarButtonItem = leftButton
        
        
        navbar.items = [item]
        
        view.addSubview(navbar)
        
        let statusBarFiller = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: UIApplication.shared.statusBarFrame.height))
        statusBarFiller.backgroundColor = UIColor.colorWithRGB(rgbValue: 0xf9f9f9)
        
        view.addSubview(statusBarFiller)
        
    }
    
    func initTableview() {
        tableview = UITableView(frame: CGRect(x: 0, y: navbar.frame.maxY, width: view.frame.width, height: view.frame.height - navbar.frame.maxY))
        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(PersonCell.self, forCellReuseIdentifier: "person")
        
        view.addSubview(tableview)
    }

}
