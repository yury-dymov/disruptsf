//
//  AppDelegate.swift
//  escape
//
//  Created by Yury Dymov on 9/16/17.
//  Copyright © 2017 Yury Dymov. All rights reserved.
//

import UIKit
import Hyphenate
import AVFoundation
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    static let build = "yury"
    
    //static let build = "seva"
    static let pwd = "000000"
    
    var window: UIWindow?
    let locationManager = CLLocationManager()
    
    static var username: String {
        return build
    }
    
    static var other: String {
        if username == "yury" {
            return "seva"
        }
        
        return "yury"
    }

    func _initChat() {
        let options = EMOptions(appkey: "1503170916002691#escape")
        
        options?.isAutoLogin = true
        options?.isAutoAcceptGroupInvitation = true
        options?.isAutoAcceptFriendInvitation = true
        
        EMClient.shared().initializeSDK(with: options)
        EMChatDemoHelper.shareHelper.noop()
        EMClient.shared().register(withUsername: AppDelegate.username, password: AppDelegate.pwd)
        EMClient.shared().login(withUsername: AppDelegate.username, password: AppDelegate.pwd)
        EMClient.shared().contactManager.addContact(AppDelegate.other, message: "")
    }
    
    func _requestPermissions() {
        AVAudioSession.sharedInstance().requestRecordPermission({ (_) in })
        
        if (AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == .notDetermined) {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted) in
                
            })
        }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        _requestPermissions()
        _initChat()
        
        self.window = UIWindow()
        
        window?.rootViewController = UINavigationController(rootViewController: LandingViewController())
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
        if AppDelegate.build == "yury" {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
                // EMClient.shared().callManager.start!(EMCallTypeVideo, remoteName: AppDelegate.other, ext: "") { (session, error) in }
            })
        }

        
        
        // Override point for customization after application launch.
        return true
    }

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

