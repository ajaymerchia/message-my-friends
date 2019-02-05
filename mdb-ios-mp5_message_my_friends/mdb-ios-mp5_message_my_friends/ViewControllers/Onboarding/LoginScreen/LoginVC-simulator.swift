//
//  LoginVC-simulator.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/3/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import Foundation
import iosManagers
import UIKit
import FirebaseAuth

extension LoginVC {
    func bypassWithSimulator() {
        
        var testingNum = 0
        
        alerts.getTextInput(withTitle: "Which Account Number?", andPlaceholder:  "0 = max, 1 = vids, 2 = anmol", completion: {(number) in
            guard let newNum = Int(number) else { return }
            testingNum = newNum
            
            self.continueBypassWith(accountID: testingNum)
            
        }, cancellation: {
            self.continueBypassWith(accountID: testingNum)
        })
        
        
    }
    
    func continueBypassWith(accountID: Int) {
        let testAccounts = [("max@gmail.com", "password"), ("vidya@gmail.com", "password"), ("anmol@gmail.com", "password")]
        
        let targetAccount = testAccounts[accountID]
        
        let creating = false
        
        // For one time use
        if creating {
            for account in testAccounts {
                Auth.auth().createUser(withEmail: account.0, password: account.1, completion: {(auth, err) in
                    FirebaseAPI.logout()
                })
                
            }
            
            return
        }
        
        debugPrint(targetAccount.0)
        Auth.auth().signIn(withEmail: targetAccount.0, password: targetAccount.1) { (auth, err) in
            guard let authUser = auth?.user else { return }
            
            FirebaseAPI.getUser(for: authUser.uid, completion: { (userOpt) in
                guard let user = userOpt else {
                    self.user = User(uid: authUser.uid, email: targetAccount.0)
                    self.performSegue(withIdentifier: "login2home", sender: self)
                    return
                }
                
                self.user = user
                self.performSegue(withIdentifier: "login2home", sender: self)
                
            })
        }
    }
}
