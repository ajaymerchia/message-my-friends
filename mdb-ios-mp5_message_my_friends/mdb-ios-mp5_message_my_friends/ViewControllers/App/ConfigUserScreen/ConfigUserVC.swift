//
//  ConfigUserVC.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/3/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import UIKit
import iosManagers
import JGProgressHUD
class ConfigUserVC: UIViewController {

    var user: User!
    
    var navbar: UINavigationBar!
    var doneButton: UIBarButtonItem!
    var prompt: UILabel!
    
    var selectProfilePhoto: UIButton!
    var selectedImage: UIImage! {
        didSet {
            checkForValidConfig()
        }
    }
    
    var firstNameField: UITextField!
    var lastNameField: UITextField!
    
    var alerts: AlertManager!
    var hud: JGProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
        setupManagers()
        addUserDetails()
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
