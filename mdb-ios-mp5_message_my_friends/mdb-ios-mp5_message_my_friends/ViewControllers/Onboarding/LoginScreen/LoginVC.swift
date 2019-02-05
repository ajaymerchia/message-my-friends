//
//  LoginVC.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/2/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import UIKit
import iosManagers
import JGProgressHUD

class LoginVC: UIViewController {
    
    var logo: UIImageView!
    var gameTitle: UILabel!
    var emailField: LabeledTextField!
    var login: UIButton!
    
    var alerts: AlertManager!
    var hud: JGProgressHUD?
    
    var user: User!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupManagers()

        initUI()
        fadeIn()
        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
