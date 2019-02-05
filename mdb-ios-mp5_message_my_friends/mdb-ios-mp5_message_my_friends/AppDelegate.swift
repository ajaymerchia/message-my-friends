//
//  AppDelegate.swift
//  mdb-ios-mp5_message_my_friends
//
//  Created by Ajay Merchia on 2/2/19.
//  Copyright © 2019 Ajay Merchia. All rights reserved.
//

import UIKit
import IQKeyboardManager
import Firebase
import FirebaseDynamicLinks
import NotificationCenter
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var pendingLink: String?
    var locationManager: CLLocationManager!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        setUpLocationManagerSubscriber()
        setUpNotifications()
        
        UINavigationBar.appearance().tintColor = .theme_orange
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont.text]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont.text, NSAttributedString.Key.foregroundColor: UIColor.theme_orange], for: .normal)
        
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { (dynamiclink, error) in
            if let link = dynamiclink?.url {
                debugPrint("received link: \(link)")
//                self.pendingLink = link.absoluteString
//                let linkNotification = Notification(name: .dynamicLinkReceived, object: self, userInfo: ["link": link.absoluteString])
//                NotificationCenter.default.post(linkNotification)
//
//
                guard let currVC = (self.window?.rootViewController as? UINavigationController)?.viewControllers.last as? LoginVC else {
                    debugPrint("login not available")
                    return
                }
                
                currVC.performLogin(link: link.absoluteString)
                
                
            }
            
        }
        
        return handled
    }
}

// App States
extension AppDelegate {
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

