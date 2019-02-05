//
//  LaunchScreen-system.swift
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
    override func viewWillAppear(_ animated: Bool) {
        
    }

    override func viewDidAppear(_ animated: Bool) {
        fadeIn {
            self.checkForLogin()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navVC = segue.destination as? UINavigationController {
            if let homeVC = navVC.viewControllers.first as? HomeVC {
                homeVC.user = self.pendingUser
            }
        }
    }

    // Segue Out Functions


}
