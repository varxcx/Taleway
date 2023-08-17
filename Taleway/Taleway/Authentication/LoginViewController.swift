import UIKit
import Lottie
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

import GoogleSignIn

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var window: UIWindow?
    let logoImage = UIImageView(image: UIImage(named: "CircledLogo"))
    let textLabel = UILabel()
    let additionalLabel = UILabel()
    let welcomeLabel = UILabel()
    let usernameTextField = UITextField()
    let passwordTextField = UITextField()
    var seen = false
    let forgotPasswordButton = UIButton(type: .system)
    let labelAnimationView = LottieAnimationView(name: "X")
    let labelAnimationView2 = LottieAnimationView(name: "X")
    let animationLabel = UILabel()
    let animationLabel2 = UILabel()
    var removed = true
    let userDefaults = UserDefaults.standard
    var userNameOrMail = ""
    let registerLabel = UILabel()
     let registerButton = UIButton()
    var cordsCount = 0
    let signInButton = UIButton(type: .system)
    let signInanimationView = LottieAnimationView(name: "MovingForward")
    let googleButton = UIButton()
    let otherSigninLabel = UILabel()
    var validityUsername = false
    var validityPass = false
    let animationView1 = LottieAnimationView(name: "Google")
    var eyeButton = UIButton()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let color = UIColor(hex: 0x090916) {
            view.backgroundColor = color
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
              NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
       
        
        logoImage.frame = CGRect(x: 0, y: 0, width: 50, height: 150)
        logoImage.center = view.center
        logoImage.contentMode = .scaleAspectFit
        view.addSubview(logoImage)
        
        if !seen {
            logoImage.alpha = 1
        } else {
            logoImage.alpha = 0
        }
        
        textLabel.text = "Taleway"
        textLabel.textColor = UIColor(red: 0.957, green: 0.941, blue: 0.945, alpha: 1)
        textLabel.font = UIFont.systemFont(ofSize: 40)
        textLabel.sizeToFit()
        let labelX = logoImage.frame.maxX + 16
        let labelY = logoImage.frame.midY - textLabel.bounds.height + 10
        textLabel.frame = CGRect(x: labelX, y: labelY, width: textLabel.bounds.width, height: textLabel.bounds.height)
        textLabel.alpha = 0.0
        view.addSubview(textLabel)
        
        additionalLabel.text = "“Tell your story in your way!”"
        additionalLabel.font = UIFont.italicSystemFont(ofSize: 20)
        additionalLabel.textColor = UIColor(red: 0.957, green: 0.941, blue: 0.945, alpha: 1)
        additionalLabel.alpha = 0.0
        additionalLabel.sizeToFit()
        additionalLabel.frame = CGRect(x: labelX - 85, y: textLabel.frame.maxY + 80, width: additionalLabel.bounds.width, height: additionalLabel.bounds.height)
        view.addSubview(additionalLabel)
        
        
        
        welcomeLabel.frame = CGRect(x: 0, y: 0, width: 158, height: 41)
        welcomeLabel.textColor = UIColor(red: 0.957, green: 0.941, blue: 0.945, alpha: 1)
        welcomeLabel.font = UIFont(name: "Helvetica-Bold", size: 36)
        welcomeLabel.text = "Welcome"
        welcomeLabel.alpha = 0.0
        
        view.addSubview(welcomeLabel)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.widthAnchor.constraint(equalToConstant: 158).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: 41).isActive = true
        welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 125).isActive = true
        welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 320).isActive = true
        
        // Create and configure the username text field
        
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        // Create an attributed string with the desired text color for the placeholder
        let placeholderText = "Username or Email"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white, // Replace UIColor.red with your desired color
            .font: UIFont.systemFont(ofSize: 16),
            .shadow: NoInterentAvailableView.createTextShadow()
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        
        // Set the attributed placeholder to the username text field
        usernameTextField.attributedPlaceholder = attributedPlaceholder
        // Create a padding view with the desired width
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0)) // Adjust the width as per your requirement
        
        // Set the padding view as the left view of the text field
        usernameTextField.leftView = paddingView
        usernameTextField.leftViewMode = .always
        usernameTextField.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        usernameTextField.textColor = .white
        usernameTextField.delegate = self
        usernameTextField.layer.cornerRadius = 10
        usernameTextField.alpha = 0.0
        usernameTextField.autocorrectionType = .no
        usernameTextField.autocapitalizationType = .none
        
        view.addSubview(usernameTextField)
        
        // Apply username text field constraints
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 40),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Create and configure the password text field
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        // Create an attributed string with the desired text color for the placeholder
        let placeholderText2 = "Password"
        let attributedPlaceholder2 = NSAttributedString(string: placeholderText2, attributes: attributes)
        
        // Set the attributed placeholder to the username text field
        passwordTextField.attributedPlaceholder = attributedPlaceholder2
        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        passwordTextField.leftView = paddingView2
        passwordTextField.leftViewMode = .always
        
        passwordTextField.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        passwordTextField.textColor = .white
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.autocorrectionType = .no
        passwordTextField.isSecureTextEntry = true
        passwordTextField.alpha = 0.0
        
        view.addSubview(passwordTextField)
        
        // Apply password text field constraints
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 25),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        forgotPasswordButton.setTitle("Forgot Password?", for: .normal)
        forgotPasswordButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
        forgotPasswordButton.alpha = 0.0
        view.addSubview(forgotPasswordButton)
        
        // Set constraints for the "Forgot Password" button
        forgotPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8).isActive = true
        forgotPasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        labelAnimationView.contentMode = .scaleAspectFit
        labelAnimationView.loopMode = .loop
        labelAnimationView.alpha = 0.0
        view.addSubview(labelAnimationView)
        labelAnimationView.play()
        labelAnimationView.translatesAutoresizingMaskIntoConstraints = false

        animationLabel.alpha = 0.0
        animationLabel.font = UIFont.systemFont(ofSize: 10)
        animationLabel.textColor = .red
        view.addSubview(animationLabel)
        
        animationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.labelAnimationView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            self.labelAnimationView.topAnchor.constraint(equalTo: self.usernameTextField.bottomAnchor, constant: -5),
            self.labelAnimationView.widthAnchor.constraint(equalToConstant: 40),
            self.labelAnimationView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            self.animationLabel.leadingAnchor.constraint(equalTo: self.labelAnimationView.trailingAnchor, constant: -5),
            self.animationLabel.topAnchor.constraint(equalTo: self.labelAnimationView.topAnchor, constant: 8),
            self.animationLabel.trailingAnchor.constraint(equalTo: self.usernameTextField.trailingAnchor, constant: 10),
            self.animationLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        
        labelAnimationView2.contentMode = .scaleAspectFit
        labelAnimationView2.loopMode = .loop
        labelAnimationView2.alpha = 0.0
        view.addSubview(labelAnimationView2)
        labelAnimationView2.play()
        labelAnimationView2.translatesAutoresizingMaskIntoConstraints = false
        
        animationLabel2.text = "Minimum 8 characters"
        animationLabel2.alpha = 0.0
        animationLabel2.font = UIFont.systemFont(ofSize: 10)
        animationLabel2.textColor = .red
        view.addSubview(animationLabel2)
        
        animationLabel2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.labelAnimationView2.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            self.labelAnimationView2.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: -5),
            self.labelAnimationView2.widthAnchor.constraint(equalToConstant: 40),
            self.labelAnimationView2.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            self.animationLabel2.leadingAnchor.constraint(equalTo: self.labelAnimationView2.trailingAnchor, constant: -5),
            self.animationLabel2.topAnchor.constraint(equalTo: self.labelAnimationView2.topAnchor, constant: 8),
            self.animationLabel2.trailingAnchor.constraint(equalTo: self.passwordTextField.trailingAnchor, constant: 10),
            self.animationLabel2.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        
      
        
        
        
        signInButton.alpha = 0.0
        signInButton.tintColor = .white
        signInButton.setBackgroundImage(UIImage(named: "Gradient"), for: .normal)
        signInButton.setImage(UIImage(systemName: "arrow.forward"), for: .normal)
        signInButton.layer.cornerRadius = 0.5 * 60 // Assuming button height is 60, adjust as needed
        
        
        
        signInButton.layer.shadowColor = UIColor.gray.cgColor
               signInButton.layer.shadowOffset = CGSize(width: -10, height: 60)
               signInButton.layer.shadowRadius = 33
               signInButton.layer.shadowOpacity = 0.6
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.isEnabled = false
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        
        
        view.addSubview(signInButton)
        
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 15),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            signInButton.widthAnchor.constraint(equalToConstant: 60),
            signInButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
      
        
      
        otherSigninLabel.text = "or Sign In with Google."
        otherSigninLabel.textColor = .gray
        otherSigninLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(otherSigninLabel)
        
        googleButton.alpha = 0.0
        otherSigninLabel.alpha = 0.0
        googleButton.layer.cornerRadius = 0.5 * 90
        
        
        view.addSubview(googleButton)

        
        
        
        // Add animation views to the buttons
        googleButton.addSubview(animationView1)
    
        animationView1.isUserInteractionEnabled = true
        animationView1.contentMode = .scaleAspectFill
        
        animationView1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAnimationTap)))
        
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        animationView1.translatesAutoresizingMaskIntoConstraints = false
     
        
        NSLayoutConstraint.activate([
            otherSigninLabel.topAnchor.constraint(equalTo: signInButton.bottomAnchor,constant: 10),
            otherSigninLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 115),
            otherSigninLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            otherSigninLabel.widthAnchor.constraint(equalToConstant: 50),
            otherSigninLabel.heightAnchor.constraint(equalToConstant: 50),
            googleButton.topAnchor.constraint(equalTo: otherSigninLabel.bottomAnchor, constant: -20),
            googleButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -55),
            googleButton.widthAnchor.constraint(equalToConstant: 120),
            googleButton.heightAnchor.constraint(equalToConstant: 90),
            animationView1.centerXAnchor.constraint(equalTo: googleButton.centerXAnchor),
            animationView1.centerYAnchor.constraint(equalTo: googleButton.centerYAnchor),
            animationView1.widthAnchor.constraint(equalToConstant: 50),
            animationView1.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Set initial positions for buttons

        registerButton.setTitle("Register Here", for: .normal)
        registerButton.setTitleColor(.systemBlue, for: .normal)
        registerButton.backgroundColor = .clear


        registerLabel.text = "New to Taleway?"
        registerLabel.textColor = .white
        registerLabel.alpha = 0.0
        registerButton.alpha = 0.0
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)

        // Add the buttons and label to the view
        view.addSubview(registerButton)
        view.addSubview(registerLabel)

        // Enable Auto Layout
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerLabel.translatesAutoresizingMaskIntoConstraints = false

        // Set constraints for the registerButton
        NSLayoutConstraint.activate([
            registerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 90),
            registerLabel.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: 30),
            registerLabel.heightAnchor.constraint(equalToConstant: 40)
        ])

        NSLayoutConstraint.activate([
            registerButton.leadingAnchor.constraint(equalTo: registerLabel.trailingAnchor, constant: -22),
            registerButton.centerYAnchor.constraint(equalTo: registerLabel.centerYAnchor),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            registerLabel.heightAnchor.constraint(equalToConstant: 35)
           
        ])


        
        let userImageView = UIImageView(image: UIImage(systemName: "person.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal))
        let animationContainerView = UIView()
        animationContainerView.addSubview(userImageView)

        // Adjust the frame of the animation container view to add padding
        let padding: CGFloat = 8

        userImageView.frame = CGRect(x: padding, y: 0, width: userImageView.frame.width, height: userImageView.frame.height)
        animationContainerView.frame = CGRect(x: 0, y: 0, width: userImageView.frame.width + padding + 5, height: userImageView.frame.height)


        // Assign the animation container view as the left view of the text field
        usernameTextField.leftView = animationContainerView
        usernameTextField.leftViewMode = .always
        
        
        let userImageView2 = UIImageView(image: UIImage(systemName: "lock.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal))
        let animationContainerView2 = UIView()
        animationContainerView2.addSubview(userImageView2)

        // Adjust the frame of the animation container view to add padding
        let padding2: CGFloat = 8

        userImageView2.frame = CGRect(x: padding2, y: 0, width: userImageView2.frame.width, height: userImageView2.frame.height)
        animationContainerView2.frame = CGRect(x: 0, y: 0, width: userImageView2.frame.width + padding2 + 5, height: userImageView2.frame.height)
        

        // Assign the animation container view as the left view of the text field
        passwordTextField.leftView = animationContainerView2
        passwordTextField.leftViewMode = .always
       
        
        eyeButton.setImage(UIImage(systemName: "eye.slash")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        eyeButton.addTarget(self, action: #selector(eyeButtonTapped), for: .touchUpInside)
        eyeButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)

        // Create a container view to hold the eye button
        let eyeViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
        eyeViewContainer.addSubview(eyeButton)

        // Assign the container view as the right view of the text field
        passwordTextField.rightView = eyeViewContainer
        passwordTextField.rightViewMode = .always



        passwordTextField.delegate = self
        
        // Add the editingChanged event target to the email text field
        passwordTextField.addTarget(self, action: #selector(passWordTextFieldEditingEnd(_:)), for: .editingDidEnd)
        passwordTextField.addTarget(self, action: #selector(passWordTextFieldEditingChanged(_:)), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(emailTextFieldEditingChanged(_:)), for: .editingDidEnd)
        usernameTextField.addTarget(self, action: #selector(emailTextFieldChanged(_:)), for: .editingChanged)
        
        
        if !seen {
            UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseInOut, animations: {
                let scaleTransform = CGAffineTransform(translationX: -80, y: -300)
                self.logoImage.transform = scaleTransform
                self.textLabel.transform = scaleTransform
                self.additionalLabel.transform = scaleTransform
            }) { (finished) in
                self.animateTextLabelWriting()
            }
        } else {
            let scaleTransform = CGAffineTransform(translationX: -80, y: -300)
            self.logoImage.transform = scaleTransform
            self.textLabel.transform = scaleTransform
            self.additionalLabel.transform = scaleTransform
           
            UIView.animate(withDuration: 0.5, animations: { [self] in
                self.welcomeLabel.alpha = 1.0
                self.textLabel.alpha = 1.0
                self.logoImage.alpha = 1.0
                self.usernameTextField.alpha = 1.0
                self.passwordTextField.alpha = 1.0
                self.additionalLabel.alpha = 1.0
                self.forgotPasswordButton.alpha = 1.0
                self.signInButton.alpha = 1.0
                self.otherSigninLabel.alpha = 1.0
                self.registerLabel.alpha = 1.0
                self.registerButton.alpha = 1.0

 
                animationView1.play()
              
                
                UIView.animate(withDuration: 0.6, delay: 0.0, options: [.curveEaseOut], animations: {
                    self.googleButton.alpha = 1.0
                    self.googleButton.transform = CGAffineTransform(translationX: 0, y: -20)
                }, completion: { _ in
                    UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [], animations: {
                        self.googleButton.transform = .identity
                    }, completion: nil)
                })
                
            })
           
        }
        
       
    }
    
    @objc func registerTapped(_sender: UIButton) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    let window = UIWindow(windowScene: windowScene)
                    let vc = RegisterViewController()
                    // Set the window property of the target view controller
                    vc.window = window
                    
                    // Present the target view controller
                    window.rootViewController = vc
                    window.makeKeyAndVisible()
                }
    }
    
    @objc func forgotPasswordButtonTapped(_ sender: UIButton) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    let window = UIWindow(windowScene: windowScene)
                    let vc = ForgotPasswordViewController()
                    // Set the window property of the target view controller
                    vc.window = window
                    
                    // Present the target view controller
                    window.rootViewController = vc
                    window.makeKeyAndVisible()
                }
        
    }
    
    @objc func keyboardWillShow(notification: Notification) {
           guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
               return
           }
           
           // Adjust the content view's frame based on the keyboard height
    
        let newOriginY = -25.0
              
              // Move the view up with animation
              UIView.animate(withDuration: 0.3) {
                  self.view.frame.origin.y = newOriginY
              }
       }
       
       @objc func keyboardWillHide(notification: Notification) {
           // Reset the content view's frame when the keyboard is hidden
           view.frame.origin.y = 0
       }
       
       @objc func dismissKeyboard() {
           view.endEditing(true)
       }
    
    @objc func signInButtonTapped(_ sender: UIButton) {
        // Set up the animation view
        sender.setImage(nil, for: .normal)
        self.signInanimationView.translatesAutoresizingMaskIntoConstraints = false
        self.signInanimationView.contentMode = .scaleToFill
        self.signInanimationView.alpha = 0.7
        self.signInanimationView.animationSpeed = 0.5
        self.signInanimationView.loopMode = .loop
        self.signInanimationView.play()
                signInButton.addSubview(self.signInanimationView)
    
                      NSLayoutConstraint.activate([
                        signInanimationView.centerXAnchor.constraint(equalTo: signInButton.centerXAnchor),
                        signInanimationView.centerYAnchor.constraint(equalTo: signInButton.centerYAnchor),
                        signInanimationView.widthAnchor.constraint(equalToConstant: 40),
                        signInanimationView.heightAnchor.constraint(equalToConstant: 40)
                      ])
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.signInanimationView.removeFromSuperview()
            self.signInButton.setImage(UIImage(systemName: "arrow.forward")?.withTintColor(.black), for: .normal)
        }
        
        
        if userNameOrMail == "userName" {
            
            fetchUserEmail(username: self.usernameTextField.text ?? "") { email in
                if let email = email {
                       // Use the email value if it exists
                    Auth.auth().signIn(withEmail: email, password: self.passwordTextField.text ?? "") { [weak self] authResult, error in
                        guard let strongSelf = self else { return }
                        if let error = error {
                            // Handle the error
                            print("Sign in failed: \(error.localizedDescription)")
                            return
                        }
                        
                        // Sign in successful, access the authResult
                        if let user = authResult?.user {
                            // User signed in successfully
                            print("User signed in: \(user.uid)")
                            self?.userDefaults.set(true, forKey: "isLoggedIn")
                            // Optionally, you can also store the user's ID or any other necessary information
                            self?.userDefaults.set(user.uid, forKey: "userID")
                            // You can access other properties of the user from `authResult`
                            // For example: user.email, user.displayName, etc.
                        }
                        
                    }
                   } else {
                       // Email not found or error occurred
                       print("User email not found")
                   }
            }
            
          
        }
        else if userNameOrMail == "mail" {
            
            Auth.auth().signIn(withEmail: usernameTextField.text ?? "", password: passwordTextField.text ?? "") { [weak self] authResult, error in
                guard let strongSelf = self else { return }
                if let error = error {
                    // Handle the error
                    print("Sign in failed: \(error.localizedDescription)")
                    return
                }
                
                // Sign in successful, access the authResult
                if let user = authResult?.user {
                    // User signed in successfully
                    print("User signed in: \(user.uid)")
                    
                    // You can access other properties of the user from `authResult`
                    // For example: user.email, user.displayName, etc.
                }
                
            }
        }
    }
    
    @objc func handleAnimationTap(_ sender: UITapGestureRecognizer) {
        guard let animationView = sender.view as? LottieAnimationView else {
            return
        }
        
        if animationView.isAnimationPlaying {
            
        } else {
            animationView.play()
            
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                return
            }

            // Create Google Sign In configuration object.
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config

            // Start the sign in flow!
            GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
                guard error == nil else {
                    // Handle the error case, if needed
                    return
                }

                guard let user = result?.user,
                      let idToken = user.idToken?.tokenString
                else {
                    // Handle the missing user or idToken case, if needed
                    return
                }

                let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                               accessToken: user.accessToken.tokenString)

                Auth.auth().signIn(with: credential) { result, error in

                    if let error = error {
                        // Handle the error
                        print("Sign in failed: \(error.localizedDescription)")
                
                        
                        return
                    }
                    
                    // Sign in successful, access the authResult
                    if let user = result?.user {
                        // User signed in successfully
                        print("User signed in: \(user.email)")
                        
                        
                        
                        // You can access other properties of the user from `authResult`
                        // For example: user.email, user.displayName, etc.
                    }
                }
            }
            
        }
    }
    
    
    
    @objc func eyeButtonTapped() {
        passwordTextField.isSecureTextEntry.toggle()
        let buttonImage = passwordTextField.isSecureTextEntry ? UIImage(systemName: "eye.slash") : UIImage(systemName: "eye")
        eyeButton.setImage(buttonImage?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
    }
    
    private func animateTextLabelWriting() {
        guard let text = textLabel.text else { return }
        
        textLabel.text = ""
        textLabel.alpha = 1.0
        
        var charIndex = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            guard charIndex < text.count else {
                timer.invalidate()
                self.animateAdditionalLabelWriting()
                return
            }
            
            let index = text.index(text.startIndex, offsetBy: charIndex)
            let character = String(text[index])
            self.textLabel.text?.append(character)
            
            charIndex += 1
        }
    }
    
    private func animateAdditionalLabelWriting() {
        guard let additionalText = additionalLabel.text else { return }
        
        additionalLabel.text = ""
        additionalLabel.alpha = 1.0
        
        var charIndex = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.06, repeats: true) { timer in
            guard charIndex < additionalText.count else {
                timer.invalidate()
                UIView.animate(withDuration: 0.5, animations: { [self] in
                    self.welcomeLabel.alpha = 1.0
                    self.usernameTextField.alpha = 1.0
                    self.passwordTextField.alpha = 1.0
                    self.forgotPasswordButton.alpha = 1.0
                    self.signInButton.alpha = 1.0
                    self.otherSigninLabel.alpha = 1.0
                    self.registerLabel.alpha = 1.0
                    self.registerButton.alpha = 1.0

     
                    animationView1.play()
                  
                    
                    UIView.animate(withDuration: 0.6, delay: 0.0, options: [.curveEaseOut], animations: {
                        self.googleButton.alpha = 1.0
                        self.googleButton.transform = CGAffineTransform(translationX: 0, y: -20)
                    }, completion: { _ in
                        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [], animations: {
                            self.googleButton.transform = .identity
                        }, completion: nil)
                    })
                    
                })
                return
            }
            
            let index = additionalText.index(additionalText.startIndex, offsetBy: charIndex)
            let character = String(additionalText[index])
            self.additionalLabel.text?.append(character)
            
            charIndex += 1
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        if validityPass && validityUsername {
            self.signInButton.isEnabled = true
            self.signInButton.sendActions(for: .touchUpInside)
        }
        return true
    }
    //     usernameTextField.addTarget(self, action: #selector(emailTextFieldEditingChanged(_:)), for: .editingDidEnd)
    //     usernameTextField.addTarget(self, action: #selector(emailTextFieldChanged(_:)), for: .editingChanged)
    @objc func emailTextFieldChanged(_ textField: UITextField) {
        self.animationLabel.alpha = 0.0
        self.labelAnimationView.alpha = 0.0
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 0.0
        textField.textColor = .white
        
    }
    
    @objc func emailTextFieldEditingChanged(_ textField: UITextField) {
        guard let text = textField.text else {
            updateValidationStatus(false, for: textField)
            return
        }
        
        if text.contains("@") {
            userNameOrMail = "mail"

            validateEmail(email: text) { emailExists in
                
                if emailExists {
                    // Email already exists
                    self.updateValidationStatus(true, for: textField)
                } else {
                    self.updateValidationStatus(false, for: textField)
                    print("Email Does not exsists")
                }
            }
        } else {
            validateUsername(text) { isValid in
                self.userNameOrMail = "userName"
                self.updateValidationStatus(isValid, for: textField)
            }
        }
    }
    
    
    
    @objc func passWordTextFieldEditingChanged(_ textField: UITextField) {
        self.animationLabel2.alpha = 0.0
        self.labelAnimationView2.alpha = 0.0
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 0.0
        textField.textColor = .white
    
        
    }
    
 

    
    @objc func passWordTextFieldEditingEnd(_ textField: UITextField) {
        guard let text = textField.text else {
            updateValidationStatusPass(false, for: textField)
            return
        }
        
       
            let isValidPass = validatePassword(text)
        updateValidationStatusPass(isValidPass, for: textField)
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        return (newString?.trimmingCharacters(in: .whitespaces) == newString)
    }
    
    // Validate email format
    func validateEmail(email: String, completion: @escaping (Bool) -> Void) {
        
        guard !email.isEmpty else {
            // Handle the empty username case
            completion(false)
            self.animationLabel.text = "Please Enter a Email"
            return
        }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if !emailPredicate.evaluate(with: email) {
            self.animationLabel.text = "Email Format Incorrect"
            completion(emailPredicate.evaluate(with: email))
            return
        }
        
        
        if emailPredicate.evaluate(with: email) {
            
            Auth.auth().fetchSignInMethods(forEmail: email) { signInMethods, error in
                if let error = error {
                    // Handle error
                    completion(false)
                    return
                }
                
                if let signInMethods = signInMethods {
                    // If the array of signInMethods is not empty, it means the email already exists
                    let emailExists = !signInMethods.isEmpty
                    completion(emailExists)
                } else {
                    // Handle empty signInMethods array
                    self.animationLabel.text = "Email Does not Exsists"
                    completion(false)
                }
            }
        }
    }
    
    
    
    func validateUsername(_ username: String, completion: @escaping (Bool) -> Void) {
        
        guard !username.isEmpty else {
            // Handle the empty username case
            completion(false)
            self.animationLabel.text = "Please Enter a Username or Email"
            return
        }
        
        let collectionRef = Firestore.firestore().collection("users").document("usersDetails").collection(username)

        collectionRef.getDocuments { (snapshot, error) in
            if let error = error {
                // Handle the error
                print("Error checking collection: \(error.localizedDescription)")
                completion(false)
                return
            }

            if let snapshot = snapshot, !snapshot.isEmpty {
                // Collection exists for the username
               
                completion(true)
            } else {
                // Collection does not exist for the username
                self.animationLabel.text = "Username Not Found"
           
                completion(false)
            }
        }
    }
    
    func fetchUserEmail(username: String, completion: @escaping (String?) -> Void) {
        
        guard !username.isEmpty else {
            // Handle the empty username case
            completion("Empty Input")
            return
        }
        
        let userDetailsRef = Firestore.firestore().collection("users").document("usersDetails").collection(username).document("userData")
            
            userDetailsRef.getDocument { (document, error) in
                if let error = error {
                    // Handle the error
                    print("Error fetching user data: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                if let document = document, document.exists,
                   let email = document.data()?["email"] as? String {
                    // Email field exists in the document
                    completion(email)
                } else {
                    // Email field does not exist or document not found
                    completion(nil)
                }
            }
    }
    
    
  
    
    func validatePassword(_ password: String) -> Bool {
        guard !password.isEmpty else {
            // Handle the empty username case
           
            self.animationLabel2.text = "Please Enter a Password"
            return false
        }
        
        let minPasswordLength = 8
        self.animationLabel2.text = "Minimum 8 Characters"
        return password.count >= minPasswordLength
        
    }
    
    // Update validation status for the text field
    func updateValidationStatus(_ isValid: Bool, for textField: UITextField) {
        if isValid {
            // Valid email format or username, remove the validation UI
            textField.layer.borderColor = UIColor.clear.cgColor
            textField.textColor = .white
            textField.layer.borderWidth = 0.0
            self.animationLabel.alpha = 0.0
            self.labelAnimationView.alpha = 0.0
            self.validityUsername = true
            if validityPass && validityUsername {
                self.signInButton.isEnabled = true
            }
           
        } else {
            // Invalid email format or username, show the validation UI
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.borderWidth = 1.0
            self.signInButton.isEnabled = false
            self.validityUsername = false
            textField.textColor = .red
            self.labelAnimationView.alpha = 1.0
            self.animationLabel.alpha = 1.0
            LoginViewController.shakeTextField(textField)
            
           
        }
    }
    
    func updateValidationStatusPass(_ isValid: Bool, for textField: UITextField) {
        if isValid {
            // Valid email format or username, remove the validation UI
            textField.layer.borderColor = UIColor.clear.cgColor
            textField.textColor = .white
            textField.layer.borderWidth = 0.0
            self.animationLabel2.alpha = 0.0
            self.labelAnimationView2.alpha = 0.0
            self.validityPass = true
            if validityPass && validityUsername {
                self.signInButton.isEnabled = true
            }
        } else {
            // Invalid email format or username, show the validation UI
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.borderWidth = 1.0
            textField.textColor = .red
            self.labelAnimationView2.alpha = 1.0
            self.signInButton.isEnabled = false
            self.validityPass = false
            self.animationLabel2.alpha = 1.0
            LoginViewController.shakeTextField(textField)
            
          
        }
    }
    
    static func shakeTextField(_ textField: UITextField) {
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.duration = 0.1
        animation.repeatCount = 4
        animation.values = [
            NSValue(cgPoint: CGPoint(x: textField.center.x - 5.0, y: textField.center.y)),
            NSValue(cgPoint: CGPoint(x: textField.center.x + 5.0, y: textField.center.y))
        ]
        textField.layer.add(animation, forKey: "shake")
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
           impactFeedback.prepare()
           impactFeedback.impactOccurred()
    }
    
    
}
