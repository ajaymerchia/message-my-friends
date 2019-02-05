//
//  HomeVC.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/2/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import iosManagers

class HomeVC: UIViewController {

    var user: User!
    var friendToChat: User!
    var chatToShow: Chat!
    var friendsAppend: String!
    
    var mapview: MKMapView!
    
    let recenterSize: CGFloat = 1.4
    var recenterButton: UIButton!
    var trueTop: CGFloat {
        return self.navigationController!.navigationBar.frame.maxY
    }
    var trueHeight: CGFloat {
        return self.view.frame.height - trueTop
    }
    
    var friendTable: UITableView!
    var longPressGesture: UILongPressGestureRecognizer!
    var userLocationAccuracyCircle: MKCircle!
    let borderColor = rgba(0, 88, 230, 0.7)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        LocalData.putLocalData(forKey: .uid, data: self.user.uid)
        setupManagers()
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
