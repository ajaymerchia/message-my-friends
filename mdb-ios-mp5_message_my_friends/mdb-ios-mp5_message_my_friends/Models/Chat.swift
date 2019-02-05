//
//  Chat.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/2/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import Foundation
import iosManagers

class Chat: FirebaseReady {
    var users = [String]()
    
    var uid: String!
    var messages = [String: Message]()
    
    init(u1: String, u2: String) {
        self.users = [u1, u2].sorted()
        self.uid = self.users.joined()
    }
    
    func createPushable() -> [String : Any?] {
        var ret = [String: Any?]()
        ret["users"] = self.users
        ret["messages"] = messages.mapValues({ (m) -> [String: Any?] in return m.createPushable() })
        return ret
    }
    
    required init(key: String, record: [String : Any?]) {
        self.uid = key
        self.users = record["users"] as? [String] ?? []
        
        guard let messageRecords = record["messages"] as? [String: [String: Any?]] else {
            return
        }
        
        for (msgID, msgContents) in messageRecords {
            self.messages[msgID] = Message(key: msgID, record: msgContents)
        }
        
    }
}

class Message: FirebaseReady, Comparable {
    
    var uid: String!
    var timeSent: Date!
    var senderID: String!
    var msg: String!
    
    init(msg: String, sender: User) {
        self.uid = assortedHelpers.uuid()
        self.timeSent = Date()
        self.senderID = sender.uid
        self.msg = msg
    }
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.timeSent > rhs.timeSent
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    func createPushable() -> [String : Any?] {
        var ret:[String: Any?] = [:]
        
        ret["time"] = timeSent.description
        ret["sender"] = senderID
        ret["msg"] = msg
        
        return ret
    }
    required init(key: String, record: [String : Any?]) {
        self.uid = key
        self.timeSent = (record["time"] as? String)?.toDateTime()
        self.senderID = record["sender"] as? String ?? ""
        self.msg = record["msg"] as? String
    }
    
}

