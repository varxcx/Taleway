//
//  ViewController.swift
//  Taleway
//
//  Created by Vardhan Chopada on 6/22/23.
//

import UIKit
import Reachability

class ViewController: UIViewController {
    
    static let isLoggenIn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let color = UIColor(hex: 0x090916) {
            // Use the color object
            // For example, set it as the background color of a view
            view.backgroundColor = color
        }
        
        checkInternetConnection()
        
        
    }
    
    func checkInternetConnection() {
        let reachability = try! Reachability()
        
        switch reachability.connection {
        case .wifi, .cellular:
            // Internet connection is available
            if ViewController.isLoggenIn == false {
                
                
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            let window = UIWindow(windowScene: windowScene)
                            let vc = LoginViewController()
                            // Set the window property of the target view controller
                            vc.window = window
                            
                            // Present the target view controller
                            window.rootViewController = vc
                            window.makeKeyAndVisible()
                        }
            }
            
            
            
        case .unavailable:
            // No internet connection
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        let window = UIWindow(windowScene: windowScene)
                        let vc = NoInterentAvailableView()
                        // Set the window property of the target view controller
                        vc.window = window
                        
                        // Present the target view controller
                        window.rootViewController = vc
                        window.makeKeyAndVisible()
                    }
        case .none:
            print("Unstable Connection")
        }
    }
}


