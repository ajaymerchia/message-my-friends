//
//  User.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/2/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import UserNotifications
import iosManagers

class User: Equatable, Comparable {

    // REQUIRED
    var uid: String!
    var email: String!
    
    // USER INFO
    var first: String!
    var last: String!
    var photo: UIImage?
    
    // SOCIAL
    private(set) var friendStatuses = [String: String]()
    private(set) var friendIDs = [String: String]()
    private(set) var friends = [String: User]()
    
    
    var sortedFriends: [User] {
        return Array(self.friends.values).sorted()
    }
    var friendHash: String {
        return sortedFriends.map({ (user) -> String in return user.uid + (friendStatuses[user.uid] ?? "")}).reduce("", +)
    }
    
    
    private(set) var friendToChatID = [String: String]()
    var chats = [String: Chat]()
    var lastUpdate: CLLocation?
    
    // Computed Properties
    var fullname: String {
        return "\(first!) \(last!)"
    }
    var complete: Bool {
        return (first != nil && last != nil && photo != nil)
    }
    
    
    
    func add(friend: User, withStatus: String) {
        friends[friend.uid] = friend
        friendIDs[friend.uid] = friend.fullname
        friendStatuses[friend.uid] = withStatus
    }
    func remove(friend: User) {
        friends.removeValue(forKey: friend.uid)
        friendIDs.removeValue(forKey: friend.uid)
        friendStatuses.removeValue(forKey: friend.uid)
    }
    func hide(friend: User) {
        friendStatuses[friend.uid] = "hiding"
    }
    func unhide(friend: User) {
        friendStatuses[friend.uid] = "friends"
    }
    func getChat(for friend: User, completion: @escaping (Chat) -> ()) {
        let fallback = Chat(u1: self.uid, u2: friend.uid)
        
        if let chat = self.chats[friend.uid] {
            completion(chat)
            return
        }
        
        FirebaseAPI.getChat(with: fallback.uid) { (chatOpt) in
            guard let chat = chatOpt else {
                FirebaseAPI.initChat(for: fallback, completion: {
                    completion(fallback)
                })
                
                return
            }
            
            self.chats[friend.uid] = chat
            completion(chat)
            
        }
        
    }
    
    
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
    
    
    func createPushable() -> [String : Any?] {
        var ret = [String: Any?]()
        
        ret["email"] = email
        ret["first"] = first
        ret["last"] = last
        ret["friends"] = self.friendIDs
        ret["statuses"] = friendStatuses
        ret["chats"] = self.friendToChatID
        ret["location"] = lastUpdate?.createPushable()
        
        return ret
    }
    
    required init(key: String, record: [String : Any?], _ withFriends: Bool = false) {
        updateUser(key: key, record: record, withFriends)
    }
    
    func updateUser(key: String, record: [String : Any?], _ withFriends: Bool = false) {
        self.uid = key
        self.email = record["email"] as? String ?? nil
        self.first = record["first"] as? String ?? nil
        self.last = record["last"] as? String ?? nil
        
        if let friendRecords = record["friends"] as? [String: String] {
            self.friendIDs = friendRecords
        }
        
        if withFriends {
            FirebaseAPI.getUsers(forIDs: Array(self.friendIDs.keys)) { (friends) in
                self.friends = [:]
                for friend in friends {
                    self.friends[friend.uid] = friend
                }
                
                NotificationCenter.default.post(Notification(name: .friendsReceived))
                
            }
        }
        
        
        
        self.friendStatuses = record["statuses"] as? [String: String] ?? [:]
        
        // TODO: implement get chats
        self.friendToChatID = record["chats"] as? [String: String] ?? [:]
        
        if let locationData = record["location"] as? [String: Any?] {
            self.lastUpdate = CLLocation(key: "", record: locationData)
        }
    }
    
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    static func == (lhs: String, rhs: User) -> Bool {
        return lhs == rhs.uid
    }
    
    static func == (lhs: User, rhs: String) -> Bool {
        return lhs.uid == rhs
    }
    
    static func < (lhs: User, rhs: User) -> Bool {
        return lhs.first < rhs.first
    }
    
    
    
}

extension CLLocation {
    func createPushable() -> [String : Any?] {
        var ret = [String: Any?]()
        ret["coord"] = self.coordinate.createPushable()
        ret["accuracy"] = self.horizontalAccuracy.magnitude
        ret["time"] = self.timestamp.description
        
        return ret
        
    }
    
    convenience init(key: String, record: [String : Any?]) {
        let time = (record["time"] as! String).toDateTime()
        let coord = record["coord"] as! [String: Any]
        let radius = record["accuracy"] as! Double
        
        self.init(coordinate: CLLocationCoordinate2D(key: "", record: coord), altitude: 0, horizontalAccuracy: radius, verticalAccuracy: 0, timestamp: time)
    }
    
}

extension CLLocationCoordinate2D: FirebaseReady {
    
    
    func createPushable() -> [String : Any?] {
        var ret = [String: Any?]()
        
        ret["lat"] = self.latitude
        ret["lon"] = self.longitude
        
        return ret
    }
    
    init(key: String, record: [String : Any?]) {
        let lat = record["lat"] as! Double
        let lon = record["lon"] as! Double
        
        self.init(latitude: CLLocationDegrees(exactly: lat)!, longitude: CLLocationDegrees(exactly: lon)!)
    }
    
    
}
