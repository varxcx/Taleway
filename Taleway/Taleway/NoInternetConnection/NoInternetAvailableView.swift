//
//  NoInternetAvailableView.swift
//  
//
//  Created by Vardhan Chopada on 6/23/23.
//

import UIKit
import Lottie
import SystemConfiguration

class NoInterentAvailableView: UIViewController {
    
    var window: UIWindow?
    
    private var button1 = UIButton()
    private let animationView = LottieAnimationView(name: "NoConnectivity")
    private let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Uh-Oh No Internet!"
        titleLabel.font = UIFont(name: "Pixeboy", size: 40)
        titleLabel.textAlignment = .center
        titleLabel.layer.shadowColor = UIColor.white.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 3, height: 3)
        titleLabel.layer.shadowOpacity = 0.5
        titleLabel.layer.masksToBounds = false
        titleLabel.textColor = UIColor(red: 0.957, green: 0.941, blue: 0.945, alpha: 1)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        makeLabelBlink(titleLabel)
        
        animationView.contentMode = .scaleAspectFit
        animationView.layer.cornerRadius = 20
        animationView.layer.masksToBounds = true
        animationView.loopMode = .loop
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        button1 = createButton(title: "Retry?", action: #selector(retrySelected))
        let stackView = UIStackView(arrangedSubviews: [animationView, button1])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: animationView.topAnchor, constant: -20),
            
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 200),
            animationView.heightAnchor.constraint(equalToConstant: 200),
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 40),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
        animationView.play()
        stackView.layer.cornerRadius = 10
        stackView.layer.masksToBounds = true
    }
    
    
    
    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pixeboy", size: 30)
        button.titleLabel?.layer.shadowColor = UIColor.white.cgColor
        button.titleLabel?.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.titleLabel?.layer.shadowOpacity = 0.5
        button.tintColor = UIColor(red: 0.957, green: 0.941, blue: 0.945, alpha: 1)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    @objc private func retrySelected() {
        
        
        button1.setTitle("", for: .normal)
        
        let animationView = LottieAnimationView(name: "Loader2")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.5
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        button1.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: button1.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: button1.centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: button1.bounds.width - 100),
            animationView.heightAnchor.constraint(equalToConstant: button1.bounds.height - 100)
        ])
        
        animationView.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if self.isNetworkAvailable() {
                
                animationView.removeFromSuperview()
                
                if ViewController.isLoggenIn == false {
                    
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        let window = UIWindow(windowScene: windowScene)
                        let vc = LoginViewController()
                        
                        vc.window = window
                        
                        window.rootViewController = vc
                        window.makeKeyAndVisible()
                    }
                }
                
                print("Network is available")
                
            } else {
                
                animationView.removeFromSuperview()
                self.button1.setTitle("Retry?", for: .normal)
                print("Network is not available")
                self.showFailedToConnectView()
                
            }
        }
        
    }
    
    
    private func isNetworkAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    
    
    private func showFailedToConnectView() {
        
        // Create blur effect
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let animationView2 = LottieAnimationView(name: "NoInternet")
        // Create blur effect view
        let blurEffectView = UIVisualEffectView(effect: nil)
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.95
        
        view.addSubview(blurEffectView)
        
        for subview in view.subviews {
            if subview != animationView2 && subview != blurEffectView {
                subview.alpha = 0.8
            }
        }
        
        // Add animation view
        
        animationView2.frame = CGRect(x: 0, y: 0, width: 210, height: 210)
        animationView2.center = view.center
        animationView2.layer.cornerRadius = 100
        view.addSubview(animationView2)
        animationView2.loopMode = .loop
        animationView2.play()
        
        // Show the animation view
        UIView.animate(withDuration: 0.3) {
            animationView2.alpha = 1.0
            blurEffectView.effect = blurEffect
        }
        
        
        // Remove animation view after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            UIView.animate(withDuration: 0.3) {
                animationView2.alpha = 0.0
                blurEffectView.effect = nil
                
                
                for subview in self.view.subviews {
                    if subview != animationView2 && subview != blurEffectView {
                        subview.alpha = 1.0
                    }
                }
            } completion: { (_) in
                // Remove animation view from superview
                animationView2.removeFromSuperview()
                blurEffectView.removeFromSuperview()
                self.makeLabelBlink(self.titleLabel)
            }
        }
        
    }
    
    static func createTextShadow() -> NSShadow {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.gray
        shadow.shadowOffset = CGSize(width: 2, height: 2)
        shadow.shadowBlurRadius = 4
        return shadow
    }
    
    
    func makeLabelBlink(_ label: UILabel) {
        UIView.animate(withDuration: 1.6, delay: 0.0, options: [.autoreverse, .repeat], animations: {
            label.alpha = 0.5
        }, completion: nil)
    }
    
    
}
