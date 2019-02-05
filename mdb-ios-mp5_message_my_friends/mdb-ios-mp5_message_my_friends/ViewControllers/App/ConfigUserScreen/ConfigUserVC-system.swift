//
//  ConfigUserVC-system.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/3/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//
// initUI

import Foundation
import UIKit
import iosManagers
import JGProgressHUD

extension ConfigUserVC {
    func setupManagers() {
        alerts = AlertManager(view: self, stateRestoration: {
            self.hud?.indicatorView = JGProgressHUDSuccessIndicatorView(contentView: self.view)
            self.hud?.detailTextLabel.text = ""
            self.hud?.dismiss(afterDelay: 0.75, animated: true)
            
            Timer.scheduledTimer(withTimeInterval: 0.9, repeats: false, block: { (_) in
                self.exit()
            })
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }

    override func viewDidAppear(_ animated: Bool) {

    }

    override func viewWillDisappear(_ animated: Bool) {
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }

    // Segue Out Functions
    @objc func exit() {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
