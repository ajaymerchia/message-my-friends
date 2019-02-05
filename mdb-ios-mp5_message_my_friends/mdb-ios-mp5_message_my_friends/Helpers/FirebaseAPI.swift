//
//  FirebaseAPI.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/2/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase
import FirebaseStorage
import iosManagers
import CoreLocation

class FirebaseAPI {
    
    static func sendLoginEmail(to: String, completion: @escaping (String, Bool) -> ()) {
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://www.example.com")
        // The sign-in operation has to always be completed in the app.
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        actionCodeSettings.dynamicLinkDomain = "iostrainingmessagemyfriends.page.link"
        
        print(actionCodeSettings)
        
        Auth.auth().sendSignInLink(toEmail: to, actionCodeSettings: actionCodeSettings) { error in
            if let error = error {
                completion(error.localizedDescription, false)
                return
            }
            
            // The link was successfully sent. Inform the user.
            // Save the email locally so you don't need to ask the user for it again
            // if they open the link on the same device.
            completion("Check your email for link", true)
        }
    }
    
    static func login(email: String, link: String, completion: @escaping (User?) -> () ) {
        Auth.auth().signIn(withEmail: email, link: link) { (auth, err) in
            guard let usr = auth else {
                debugPrint("failed to login")
                completion(nil)
                return
            }
            completion(User(uid: usr.user.uid, email: email))
        }
    }
    
    static func getUser(for id: String, _ withFriends: Bool = true, completion: @escaping (User?) -> ()) {
        Database.database().reference().child("users").child(id).observeSingleEvent(of: .value) { (snap) in
            guard let data = snap.value as? [String: Any?] else {
                completion(nil)
                return
            }
            
            let usr = User(key: id, record: data, withFriends)
            getPhotoForUser(withID: usr.uid, completion: { (imgOpt) in
                if let img = imgOpt {
                    usr.photo = img
                }
                completion(usr)
            })
            
            
        }
    }
    
    static func updateLocal(user: User, withFriends: Bool = true, completion: @escaping () -> () ) {
        Database.database().reference().child("users").child(user.uid).observeSingleEvent(of: .value) { (snap) in
            guard let data = snap.value as? [String: Any?] else {
                completion()
                return
            }
            
            user.updateUser(key: user.uid, record: data, withFriends)
            completion()
        }
    }
    
    static func userEavesdrop(on user: User, onNewData: @escaping() -> ()) {
        Database.database().reference().child("users").child(user.uid).child("statuses").observe(.childChanged) { (_) in
            onNewData()
        }
        
    }
    
    static func getPhotoForUser(withID: String, completion: @escaping (UIImage?) -> ()) {
        let photoTarget = Storage.storage().reference().child("users").child(withID)
        
        photoTarget.getData(maxSize: 2 * 1024 * 1024, completion: { (data, err) in
            if let photoData = data {
                if let img = UIImage(data: photoData) {
                    completion(img)
                }
            } else {
                completion(nil)
            }
            
        })
    
    }
    
    static func upload(user: User, withPhoto: Bool, completion: @escaping() -> ()) {
        Database.database().reference().child("users").child(user.uid).updateChildValues(user.createPushable()) { (err, ref) in
            if !withPhoto {
                completion()
                return
            }
            
            let photoRef = Storage.storage().reference().child("users").child(user.uid)
            guard let photoData = user.photo?.jpegData(compressionQuality: 0.4) else {
                return
            }
            
            photoRef.putData(photoData, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    // Uh-oh, an error occurred!
                    debugPrint("error with photo upload")
                    completion()
                    return
                }
                completion()
            }
            
            
        }
    }
    
    
    

    static func getAllUser(completion: @escaping([User]) -> () ) {
        Database.database().reference().child("users").observeSingleEvent(of: .value) { (snap) in
            guard let data = snap.value as? [String: [String: Any?]] else {
                completion([])
                return
            }
            
            var ret = [User]()
            for (uid, userData) in data {
                getPhotoForUser(withID: uid, completion: { (imgOpt) in
                    guard let img = imgOpt else {
                        return
                    }
                    let usr = User(key: uid, record: userData)
                    usr.photo = img
                    ret.append(usr)
                    
                    if ret.count == data.count {
                        completion(ret)
                    }
                    
                })
                
                
            }
            
        }
    }
    
    static func getUsers(forIDs: [String], completion: @escaping ([User]) -> () ) {
        if forIDs.count == 0 {
            completion([])
        }
        
        var usersDownloaded: [User] = []
        var failedRequests = 0
        
        for accountID in forIDs {
            getUser(for: accountID, false) { (usr) in
                if let user = usr {
                    usersDownloaded.append(user)
                } else {
                    failedRequests += 1
                }
                
                if usersDownloaded.count == forIDs.count - failedRequests {
                    completion(usersDownloaded)
                }
            }
        }
    }
    
    static func logout() {
        do {
            print("Attempting to log out")
            try Auth.auth().signOut()
            LocalData.deleteLocalData(forKey: .email)
            LocalData.deleteLocalData(forKey: .uid)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    static func request(friend: User, from: User, completion: @escaping() -> ()) {
        friend.add(friend: from, withStatus: "pending")
        
        upload(user: friend, withPhoto: false) {
            completion()
        }
        
        
    }
    
    static func add(friend: User, to: User, completion: @escaping() -> ()) {
        // fool proof
        friend.add(friend: to, withStatus: "friends")
        to.add(friend: friend, withStatus: "friends")
        
        upload(user: friend, withPhoto: false) {
            upload(user: to, withPhoto: false, completion: {
                completion()
            })
        }
    }
    
    static func endFriendship(u1: User, u2: User, completion: @escaping() -> ()) {
        u1.remove(friend: u2)
        u2.remove(friend: u1)
        upload(user: u1, withPhoto: false) {
            upload(user: u2, withPhoto: false, completion: {
                completion()
            })
        }
    }
    
    static func changeLocationStatus(of sharer: User, from viewer: User, shown: Bool, completion: @escaping () -> () ) {
        if shown {
            viewer.unhide(friend: sharer)
        } else {
            viewer.hide(friend: sharer)
        }
        
        
        upload(user: sharer, withPhoto: false) {
            upload(user: viewer, withPhoto: false, completion: {
                completion()
            })
        }
        
    }
    
    static func update(location: CLLocation, for id: String, completion: @escaping () -> () ) {
        Database.database().reference().child("users").child(id).child("location").updateChildValues(location.createPushable()) { (err, ref) in
            completion()
        }
    }
    
    static func setFCM(token: String, for id: String, completion: @escaping () -> () ) {
        Database.database().reference().child("users").child(id).child("fcmToken").setValue(token) { (er, ref) in
            completion()
        }
    }
    
    
    // CHATS
    static func initChat(for chat: Chat, completion: @escaping ()-> ()) {
        Database.database().reference().child("chats").child(chat.uid).setValue(chat.createPushable()) { (er, ref) in
            completion()
        }
    }
    
    static func getChat(with id: String, completion: @escaping (Chat?) -> ()) {
        Database.database().reference().child("chats").child(id).observeSingleEvent(of: .value) { (snap) in
            guard let data = snap.value as? [String: Any?] else {
                completion(nil)
                return
            }
            
            let chat = Chat(key: id, record: data)
            completion(chat)
            
        }
    }
    
    static func send(msg: Message, to chat: Chat, completion: @escaping () -> ()) {
        chat.messages[msg.uid] = msg
        Database.database().reference().child("chats").child(chat.uid).child("messages").child(msg.uid).setValue(msg.createPushable()) { (err, ref) in
            completion()
        }
    }
    
    static func listenForNew(chat: Chat, onNewMessage: @escaping (Message) -> () ) {
        Database.database().reference().child("chats").child(chat.uid).child("messages").observe(.childAdded) { (snap) in
            guard let data = snap.value as? [String: Any] else {
                return
            }
            let newMsg = Message(key: snap.key, record: data)
            chat.messages[snap.key] = newMsg
            onNewMessage(newMsg)
            
        }
    }
    
    
}
