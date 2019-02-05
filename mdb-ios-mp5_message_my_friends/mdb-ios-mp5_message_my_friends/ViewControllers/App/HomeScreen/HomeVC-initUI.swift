//
//  HomeVC-initUI.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/3/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers

extension HomeVC: UIGestureRecognizerDelegate {
    func initUI() {
        initNav()
        initMap()
        initTableview()
        addTableviewGestureRecognizer()
    }

    // UI Initialization Helpers
    func initNav() {
        self.title = "Message My Friends"
        
        let leftButton = UIBarButtonItem(image: UIImage.nav_logout.withRenderingMode(.alwaysTemplate), style: .done, target: self, action: #selector(logout))
        leftButton.tintColor = .theme_orange
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToAdd))
        rightButton.tintColor = .theme_orange
        
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.rightBarButtonItem = rightButton
        
    }
    
    func initTableview() {
        friendTable = UITableView(frame: LayoutManager.belowCentered(elementAbove: mapview, padding: 0, width: view.frame.width, height: view.frame.maxY - mapview.frame.maxY))
        friendTable.dataSource = self
        friendTable.delegate = self
        friendTable.register(PersonCell.self, forCellReuseIdentifier: "person")
        
        view.addSubview(friendTable)
        
    }
    
    func addTableviewGestureRecognizer() {
        //Long Press
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delegate = self
        self.friendTable.addGestureRecognizer(longPressGesture)
    }
    
    
    
    


}
