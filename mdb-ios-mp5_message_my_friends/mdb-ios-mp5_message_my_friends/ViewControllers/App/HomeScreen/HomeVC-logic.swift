//
//  HomeVC-logic.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/3/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers

extension HomeVC {
    func checkForUserCompleteness() {
        if !self.user.complete {
            goToConfig()
        }
    }
    
    func startListeningForNewFriends() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (t) in
            let newAppending = self.user.friendHash
            if self.friendsAppend != newAppending {
                t.invalidate()
                self.updateUI()
            }
            self.friendsAppend = newAppending
        }
        
        self.friendsAppend = self.user.friendHash
    }
    
    @objc func updateData() {
        FirebaseAPI.updateLocal(user: self.user) {
            self.startListeningForNewFriends()
            self.updateUI()
        }
    }
    
    func updateUI() {
        self.friendTable.reloadData()
        self.addOtherUsers()
    }
    
    @objc func confirmFriends(_ sender: UIButton) {
        sender.isSelected = true
        let newFriend = self.user.sortedFriends[sender.tag]
        
        FirebaseAPI.add(friend: newFriend, to: self.user) {
            self.friendTable.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .fade)
        }
        
    }
    
    @objc func handleLongPress(longPressGesture:UILongPressGestureRecognizer) {
        let p = longPressGesture.location(in: self.friendTable)
        let indexPath = self.friendTable.indexPathForRow(at: p)
        guard let ind = indexPath else {
            print("Long press on table view, not row.")
            return
        }
        if (longPressGesture.state == UIGestureRecognizer.State.began) {
            print("Long press on row, at \(ind.row)")
            longPress(index: ind)
        }
    }
    
    func longPress(index: IndexPath) {
        let friendSelected = self.user.sortedFriends[index.row]
        let currentlySharing = friendSelected.friendStatuses[self.user.uid] != "hiding"
        
        let actionSheet = UIAlertController(title: friendSelected.fullname, message: friendSelected.email, preferredStyle: .actionSheet)

        if let annotation = self.mapview.annotations.filter({ (annotation) -> Bool in return annotation.title == friendSelected.fullname}).first {
            actionSheet.addAction(UIAlertAction(title: "Show on Map", style: .default, handler: { (action) -> Void in
                self.expandMap()
                self.mapview.selectAnnotation(annotation, animated: true)
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: currentlySharing ? "Stop Sharing Location" : "Resume Location Sharing", style: .default, handler: { (action) -> Void in
            FirebaseAPI.changeLocationStatus(of: self.user, from: friendSelected, shown: !currentlySharing, completion: {
                self.updateUI()
            })
        }))
        actionSheet.addAction(UIAlertAction(title: "Remove Friend", style: .destructive, handler: { (action) -> Void in
            FirebaseAPI.endFriendship(u1: self.user, u2: self.user.sortedFriends[index.row], completion: {
                debugPrint(index)
                self.friendTable.deleteRows(at: [index], with: .left)

            })
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.popoverPresentationController?.sourceView = self.friendTable.cellForRow(at: index)
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: view.center.x, y: view.center.y, width: 0, height: 0)
        actionSheet.popoverPresentationController?.sourceView = view
        actionSheet.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        self.present(actionSheet, animated: true)
    }
    
    
    func expandMap() {
        UIView.animate(withDuration: 0.5) {
            self.mapview.frame = CGRect(x: self.mapview.frame.minX, y: self.mapview.frame.minY, width: self.mapview.frame.width, height: self.view.frame.maxY - self.mapview.frame.minY)
            self.friendTable.frame = CGRect(x: 0, y: self.view.frame.height, width: self.friendTable.frame.width, height: self.friendTable.frame.height)
            self.recenterButton.frame = CGRect(x: self.mapview.frame.maxX - self.recenterSize * 1.2 * .PADDING, y: self.mapview.frame.maxY - self.recenterSize * 1.2 * .PADDING, width: self.recenterSize * .PADDING, height: self.recenterSize * .PADDING)
            
        }
    }
    
    func collapseMap() {
        UIView.animate(withDuration: 0.5) {
            self.mapview.frame = CGRect(x: 0, y: self.trueTop, width: self.view.frame.width, height: self.trueHeight/2.5)
            self.friendTable.frame = LayoutManager.belowCentered(elementAbove: self.mapview, padding: 0, width: self.view.frame.width, height: self.view.frame.maxY - self.mapview.frame.maxY)
            self.recenterButton.frame = CGRect(x: self.mapview.frame.maxX - self.recenterSize * 1.2 * .PADDING, y: self.mapview.frame.maxY - self.recenterSize * 1.2 * .PADDING, width: self.recenterSize * .PADDING, height: self.recenterSize * .PADDING)
        }
    }
    
    
    
    
    


}
