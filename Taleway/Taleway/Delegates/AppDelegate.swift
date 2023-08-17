//
//  AppDelegate.swift
//  Taleway
//
//  Created by Vardhan Chopada on 6/22/23.
//

import UIKit
import FirebaseCore
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        let userDefaults = UserDefaults.standard
        let isLoggedIn = userDefaults.bool(forKey: "isLoggedIn")
        
        if isLoggedIn {
            // User is already logged in, maintain the user's authenticated state
            // Perform any necessary actions, such as showing the main screen
            // You can also retrieve the stored user ID or any other necessary information
            let userID = userDefaults.string(forKey: "userID")
            print("You already Logged in")
        } else {
            // User is not logged in, show the login screen or perform any necessary actions
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        
      return GIDSignIn.sharedInstance.handle(url)
    }


}

