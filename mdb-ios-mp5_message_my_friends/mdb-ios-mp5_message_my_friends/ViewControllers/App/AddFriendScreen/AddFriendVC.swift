//
//  AddFriendVC.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/3/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import UIKit
import iosManagers
import JGProgressHUD

class AddFriendVC: UIViewController {

    var user: User!
    
    var navbar: UINavigationBar!
    var doneButton: UIBarButtonItem!
    
    var hud: JGProgressHUD?
    
    var tabledata = [User]()
    var tableview: UITableView!
    
    var userToSend: User!
    var currIndPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchData()
        initUI()
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
