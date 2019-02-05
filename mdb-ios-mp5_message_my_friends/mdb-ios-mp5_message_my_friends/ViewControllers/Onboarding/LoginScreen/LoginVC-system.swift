//
//  LoginVC-system.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/2/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers
import NotificationCenter

extension LoginVC {
    func setupManagers() {
        alerts = AlertManager(view: self, stateRestoration: {
            self.view.isUserInteractionEnabled = true
            self.hud?.dismiss()
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(performLogin(_:)), name: .dynamicLinkReceived, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(checkLogin), name: UIApplication.willEnterForegroundNotification, object: self)
        
    }

    override func viewWillAppear(_ animated: Bool) {

    }

    override func viewDidAppear(_ animated: Bool) {
        checkLogin()
        alerts.yesOrNo(title: "Is this for simulator override?", message: "", yes: {
            self.bypassWithSimulator()
        }) {
            debugPrint("oops")
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navVC = segue.destination as? UINavigationController {
            if let homeVC = navVC.viewControllers.first as? HomeVC {
                homeVC.user = self.user
            }
        }
    }
    
    @objc func checkLogin() {
        if let app = UIApplication.shared.delegate as? AppDelegate {
            if let link = app.pendingLink {
                performLogin(link: link)
            }
        }
    }

    // Segue Out Functions


}
