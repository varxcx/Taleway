import UIKit
import Lottie
import Photos
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth


class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    private var selectedImage: UIImage?
    var window: UIWindow?
    private let termsCheckbox = UIButton(type: .custom)
    private let logoImageView = UIImageView(image: UIImage(named: "LogoDiff"))
    private let profileImageView = UIImageView()
    private let profileButton = UIButton(type: .system)
    private let usernameTextField = UITextField()
    private let fullNameTextField = UITextField()
    private let emailTextField = UITextField()
    var eyeButton = UIButton()
    private let passwordTextField = UITextField()
    private let termsLabel = UILabel()
    private var validityTerms = false
    private var isEmpty = true
    private let signUpButton = UIButton(type: .custom)
    private let loginLabel = UILabel()
    private let labelAnimationView = LottieAnimationView(name: "X")
    private let labelAnimationView2 = LottieAnimationView(name: "X")
    private let labelAnimationView3 = LottieAnimationView(name: "X")
    private let labelAnimationView4 = LottieAnimationView(name: "X")
    private let signUpanimationView = LottieAnimationView(name: "MovingForward")
    private let animationLabel = UILabel()
    private let animationLabel2 = UILabel()
    private let animationLabel3 = UILabel()
    private let animationLabel4 = UILabel()
    private var validityUsername = false
    private var validityPass = false
    private var validityEmail = false
    private var validityFullName = false
    private let createAccountLabel = UILabel()
    private let signInButton = UIButton(type: .system)
    private var isImageSelected: Bool = false {
        didSet {
            let buttonImage = isImageSelected ? UIImage(systemName: "minus.circle.fill") : UIImage(systemName: "plus.circle.fill")
            profileButton.setImage(buttonImage?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let color = UIColor(hex: 0x090916) {

            view.backgroundColor = color
        }
        
        let swipeRightGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
            view.addGestureRecognizer(swipeRightGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
              NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
              
              // Add a tap gesture recognizer to dismiss the keyboard
              let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
              view.addGestureRecognizer(tapGesture)
        
        setupUI()
    }
    
    @objc func keyboardWillShow(notification: Notification) {
           guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
               return
           }
           
           // Adjust the content view's frame based on the keyboard height
        let offset: CGFloat = 80
              let newOriginY = -keyboardFrame.height + offset
              
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
    
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)

            // Animate fade-in effect
            UIView.animate(withDuration: 0.5) {
                self.termsCheckbox.alpha = 1.0
                self.logoImageView.alpha = 1.0
                self.profileImageView.alpha = 1.0
                self.profileButton.alpha = 1.0
                self.usernameTextField.alpha = 1.0
                self.fullNameTextField.alpha = 1.0
                self.emailTextField.alpha = 1.0
                self.passwordTextField.alpha = 1.0
                self.termsLabel.alpha = 1.0
                self.signUpButton.alpha = 1.0
                self.loginLabel.alpha = 1.0
                self.createAccountLabel.alpha = 1.0
                self.signInButton.alpha = 1.0
            }
        }

    
    private func setupUI() {
      
        termsCheckbox.alpha = 0.0
        logoImageView.alpha = 0.0
        profileImageView.alpha = 0.0
        profileButton.alpha = 0.0
        usernameTextField.alpha = 0.0
        fullNameTextField.alpha = 0.0
        emailTextField.alpha = 0.0
        passwordTextField.alpha = 0.0
        termsLabel.alpha = 0.0
        signUpButton.alpha = 0.0
        loginLabel.alpha = 0.0
        createAccountLabel.alpha = 0.0
        signInButton.alpha = 0.0
        
        // Logo at the top
       
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)
        
        // Create New Account label
      
        createAccountLabel.text = "Create New Account"
        createAccountLabel.textColor = .white
        createAccountLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        createAccountLabel.textAlignment = .center
        view.addSubview(createAccountLabel)
        
        // Image view for profile picture
       let imageProfile = UIImage(systemName: "person.circle.fill")
        profileImageView.image = imageProfile?.withTintColor(.black, renderingMode: .alwaysOriginal)
        profileImageView.backgroundColor = .gray
        profileImageView.layer.cornerRadius = 50
        profileImageView.clipsToBounds = true
        profileImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(tapGesture)
        view.addSubview(profileImageView)
        
        // Plus/Minus button on profile image
      
        profileButton.tintColor = .white
        profileButton.setBackgroundImage(UIImage(named: "Gradient"), for: .normal)
        profileButton.layer.cornerRadius = 12
        profileButton.setImage(UIImage(systemName: "plus"), for: .normal)
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        view.addSubview(profileButton)
        
        // Username text field
        let placeholderText1 = "Username"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white, // Replace UIColor.red with your desired color
            .font: UIFont.systemFont(ofSize: 16),
            .shadow: NoInterentAvailableView.createTextShadow()
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholderText1, attributes: attributes)
        
        
        usernameTextField.attributedPlaceholder = attributedPlaceholder
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.autocorrectionType = .no
        usernameTextField.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        usernameTextField.textColor = .white
        usernameTextField.delegate = self
        usernameTextField.layer.cornerRadius = 10
        view.addSubview(usernameTextField)
        
        // Email text field
        let placeholderText2 = "Email"
        let attributedPlaceholder2 = NSAttributedString(string: placeholderText2, attributes: attributes)
       
        emailTextField.attributedPlaceholder = attributedPlaceholder2
        emailTextField.borderStyle = .roundedRect
        emailTextField.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        emailTextField.textColor = .white
        emailTextField.autocorrectionType = .no
        emailTextField.autocapitalizationType = .none
        emailTextField.delegate = self
        emailTextField.layer.cornerRadius = 10
        view.addSubview(emailTextField)
        
        // Full Name text field
        let placeholderText3 = "Full Name"
        let attributedPlaceholder3 = NSAttributedString(string: placeholderText3, attributes: attributes)
       
        fullNameTextField.attributedPlaceholder = attributedPlaceholder3
        fullNameTextField.borderStyle = .roundedRect
        fullNameTextField.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        fullNameTextField.textColor = .white
        fullNameTextField.autocapitalizationType = .words
        fullNameTextField.delegate = self
        fullNameTextField.layer.cornerRadius = 10
        view.addSubview(fullNameTextField)
        
        // Password text field
        let placeholderText4 = "Password"
        let attributedPlaceholder4 = NSAttributedString(string: placeholderText4, attributes: attributes)
       
        passwordTextField.attributedPlaceholder = attributedPlaceholder4
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        passwordTextField.textColor = .white
        passwordTextField.delegate = self
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.autocorrectionType = .no
        passwordTextField.isSecureTextEntry = true
        view.addSubview(passwordTextField)
        
        // Agree to Terms checkbox

        termsCheckbox.backgroundColor = .clear
        termsCheckbox.layer.borderWidth = 2
        termsCheckbox.layer.cornerRadius = 5
        termsCheckbox.layer.borderColor = UIColor.white.cgColor
        termsCheckbox.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
        
        view.addSubview(termsCheckbox)
        
        // Agree to Terms label
        
        termsLabel.text = "Agree to Terms and Conditions"
        termsLabel.textColor = .gray
        view.addSubview(termsLabel)
        
        // Sign Up button
        
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.cornerRadius = 40
        signUpButton.tintColor = .white
        signUpButton.clipsToBounds = true
        signUpButton.setBackgroundImage(UIImage(named: "Gradient"), for: .normal)
        signUpButton.setImage(UIImage(systemName: "arrow.forward"), for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        signUpButton.layer.cornerRadius = 30
        signUpButton.isEnabled = false
        view.addSubview(signUpButton)
        
        // Already have an account label
        
        loginLabel.textColor = .white
        loginLabel.text = "Already have an account?"
        view.addSubview(loginLabel)
        
        // Sign In button
        
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        view.addSubview(signInButton)
        
        // Set up constraints
        let margin: CGFloat = 20
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        createAccountLabel.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        fullNameTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        termsCheckbox.translatesAutoresizingMaskIntoConstraints = false
        termsLabel.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Logo at the top
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: margin),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            logoImageView.widthAnchor.constraint(equalToConstant: 160),
            
            // Create New Account label
            createAccountLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: margin),
            createAccountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            createAccountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),
            
            // Image view for profile picture
            profileImageView.topAnchor.constraint(equalTo: createAccountLabel.bottomAnchor, constant: margin),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            
            // Plus/Minus button on profile image
            profileButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -2),
            profileButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -2),
            profileButton.heightAnchor.constraint(equalToConstant: 24),
            profileButton.widthAnchor.constraint(equalToConstant: 24),
            
            // Username text field
            usernameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 40),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            // Email text field
            emailTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 30),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            // Full Name text field
            fullNameTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            fullNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            fullNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            fullNameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            // Password text field
            passwordTextField.topAnchor.constraint(equalTo: fullNameTextField.bottomAnchor, constant: 30),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            // Agree to Terms checkbox
            termsCheckbox.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: margin + 10),
            termsCheckbox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin + 30),
            termsCheckbox.widthAnchor.constraint(equalToConstant: 20),
            termsCheckbox.heightAnchor.constraint(equalToConstant: 20),
            
            // Agree to Terms label
            termsLabel.centerYAnchor.constraint(equalTo: termsCheckbox.centerYAnchor),
            termsLabel.leadingAnchor.constraint(equalTo: termsCheckbox.trailingAnchor, constant: 8),
            
            // Sign Up button
            signUpButton.topAnchor.constraint(equalTo: termsCheckbox.bottomAnchor, constant: margin),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),
            signUpButton.heightAnchor.constraint(equalToConstant: 60),
            signUpButton.widthAnchor.constraint(equalToConstant: 60),
            

                loginLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
                loginLabel.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 30),
                loginLabel.heightAnchor.constraint(equalToConstant: 40),
        


                signInButton.leadingAnchor.constraint(equalTo: loginLabel.trailingAnchor, constant: -32),
                signInButton.centerYAnchor.constraint(equalTo: loginLabel.centerYAnchor),
                signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            signInButton.heightAnchor.constraint(equalToConstant: 40),
                loginLabel.heightAnchor.constraint(equalToConstant: 40)
               

        ])
        
        
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
        
        labelAnimationView3.contentMode = .scaleAspectFit
        labelAnimationView3.loopMode = .loop
        labelAnimationView3.alpha = 0.0
        view.addSubview(labelAnimationView3)
        labelAnimationView3.play()
        labelAnimationView3.translatesAutoresizingMaskIntoConstraints = false

        animationLabel3.alpha = 0.0
        animationLabel3.font = UIFont.systemFont(ofSize: 10)
        animationLabel3.textColor = .red
        view.addSubview(animationLabel3)
        
        animationLabel3.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.labelAnimationView3.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            self.labelAnimationView3.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: -5),
            self.labelAnimationView3.widthAnchor.constraint(equalToConstant: 40),
            self.labelAnimationView3.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            self.animationLabel3.leadingAnchor.constraint(equalTo: self.labelAnimationView3.trailingAnchor, constant: -5),
            self.animationLabel3.topAnchor.constraint(equalTo: self.labelAnimationView3.topAnchor, constant: 8),
            self.animationLabel3.trailingAnchor.constraint(equalTo: self.emailTextField.trailingAnchor, constant: 10),
            self.animationLabel3.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        labelAnimationView4.contentMode = .scaleAspectFit
        labelAnimationView4.loopMode = .loop
        labelAnimationView4.alpha = 0.0
        view.addSubview(labelAnimationView4)
        labelAnimationView4.play()
        labelAnimationView4.translatesAutoresizingMaskIntoConstraints = false

        animationLabel4.alpha = 0.0
        animationLabel4.font = UIFont.systemFont(ofSize: 10)
        animationLabel4.text = "Please Enter a Full Name"
        animationLabel4.textColor = .red
        view.addSubview(animationLabel4)
        
        animationLabel4.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.labelAnimationView4.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            self.labelAnimationView4.topAnchor.constraint(equalTo: self.fullNameTextField.bottomAnchor, constant: -5),
            self.labelAnimationView4.widthAnchor.constraint(equalToConstant: 40),
            self.labelAnimationView4.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            self.animationLabel4.leadingAnchor.constraint(equalTo: self.labelAnimationView4.trailingAnchor, constant: -5),
            self.animationLabel4.topAnchor.constraint(equalTo: self.labelAnimationView4.topAnchor, constant: 8),
            self.animationLabel4.trailingAnchor.constraint(equalTo: self.fullNameTextField.trailingAnchor, constant: 10),
            self.animationLabel4.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        
        passwordTextField.addTarget(self, action: #selector(passWordTextFieldEditingEnd(_:)), for: .editingDidEnd)
        passwordTextField.addTarget(self, action: #selector(passWordTextFieldEditingChanged(_:)), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(userNameTextFieldEditingEnd(_:)), for: .editingDidEnd)
        usernameTextField.addTarget(self, action: #selector(userNameTextFieldChanged(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(emailTextFieldEditingEnd(_:)), for: .editingDidEnd)
        emailTextField.addTarget(self, action: #selector(emailTextFieldChanged(_:)), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(fullNameTextFieldEditingEnd(_:)), for: .editingDidEnd)
        fullNameTextField.addTarget(self, action: #selector(fullNameTextFieldChanged(_:)), for: .editingChanged)

     
        eyeButton.setImage(UIImage(systemName: "eye.slash")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        eyeButton.addTarget(self, action: #selector(eyeButtonTapped), for: .touchUpInside)
        eyeButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)

        // Create a container view to hold the eye button
        let eyeViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
        eyeViewContainer.addSubview(eyeButton)

        // Assign the container view as the right view of the text field
        passwordTextField.rightView = eyeViewContainer
        passwordTextField.rightViewMode = .always
        
    }
    
    
    @objc func eyeButtonTapped() {
        passwordTextField.isSecureTextEntry.toggle()
        let buttonImage = passwordTextField.isSecureTextEntry ? UIImage(systemName: "eye.slash") : UIImage(systemName: "eye")
        eyeButton.setImage(buttonImage?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField  {
            fullNameTextField.becomeFirstResponder()
        } else if textField == fullNameTextField {
            passwordTextField.becomeFirstResponder()
        }
          else {
            textField.resignFirstResponder()
        }
        
        if validityPass && validityUsername  && validityFullName && validityEmail && validityTerms {
            self.signUpButton.isEnabled = true
            self.signUpButton.sendActions(for: .touchUpInside)
        }
        return true
    }
    
    
    
    @objc func fullNameTextFieldEditingEnd(_ textField: UITextField) {
        
       
  
        let fullName = textField.text ?? ""
              let nameComponents = fullName.components(separatedBy: " ")
              let isValidFullName = nameComponents.count == 2 && !nameComponents.contains { $0.isEmpty }
              updateFullNameValidationStatus(isValidFullName, for: textField)


   
    }
    
    @objc func fullNameTextFieldChanged(_ textField: UITextField) {
        self.animationLabel4.alpha = 0.0
        self.labelAnimationView4.alpha = 0.0
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 0.0
        textField.textColor = .white
        if validityPass && validityUsername && validityFullName && validityEmail && validityTerms {
            self.signUpButton.isEnabled = true
        }
    }
    
    
    @objc func passWordTextFieldEditingEnd(_ textField: UITextField) {
        guard let text = textField.text else {
            updateValidationStatusPass(false, for: textField)
            return
        }
        
       
            let isValidPass = validatePassword(text)
        updateValidationStatusPass(isValidPass, for: textField)
        
    }
    
    @objc func passWordTextFieldEditingChanged(_ textField: UITextField) {
        self.animationLabel2.alpha = 0.0
        self.labelAnimationView2.alpha = 0.0
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 0.0
        textField.textColor = .white
        if validityPass && validityUsername && validityFullName && validityEmail && validityTerms {
            self.signUpButton.isEnabled = true
        }
    }
    
    @objc func userNameTextFieldEditingEnd(_ textField: UITextField) {
        guard let text = textField.text else {
            updateValidationStatus(false, for: textField)
            return
        }
        
       
         validateUsername(text, completion: { isValid in
            self.updateValidationStatus(isValid, for: textField)
        })
        
    }
    
    @objc func signUpButtonTapped(_ sender: UIButton) {
        if validityPass && validityUsername && validityFullName && validityEmail && validityTerms {
            self.signUpButton.isEnabled = true
            sender.setImage(nil, for: .normal)
            self.signUpanimationView.translatesAutoresizingMaskIntoConstraints = false
            self.signUpanimationView.contentMode = .scaleToFill
            self.signUpanimationView.alpha = 0.7
            self.signUpanimationView.animationSpeed = 0.5
            self.signUpanimationView.loopMode = .loop
            self.signUpanimationView.play()
                    signUpButton.addSubview(self.signUpanimationView)
        
                          NSLayoutConstraint.activate([
                            signUpanimationView.centerXAnchor.constraint(equalTo: signUpButton.centerXAnchor),
                            signUpanimationView.centerYAnchor.constraint(equalTo: signUpButton.centerYAnchor),
                            signUpanimationView.widthAnchor.constraint(equalToConstant: 40),
                            signUpanimationView.heightAnchor.constraint(equalToConstant: 40)
                          ])
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.signUpanimationView.removeFromSuperview()
                self.signUpButton.setImage(UIImage(systemName: "arrow.forward")?.withTintColor(.black), for: .normal)
            }
            
            
           let defaultImage = UIImage(named: "Logo") ?? UIImage()
            
            self.saveUserData(username: usernameTextField.text ?? "Invalid", password: passwordTextField.text ?? "Invalid", email: emailTextField.text ?? "Invalid", fullName: fullNameTextField.text ?? "Invalid", image: profileImageView.image ?? defaultImage)
            
            
            
            
        } else {
            if !validityPass {
                updateValidationStatusPass(validityPass, for: passwordTextField)
            }
            if !validityUsername {
                updateValidationStatus(validityUsername, for: usernameTextField)
            }
            if !validityFullName {
                updateFullNameValidationStatus(validityFullName, for: fullNameTextField)
            }
            if !validityEmail {
                updateEmailValidationStatus(validityEmail, for: emailTextField)
            }
            if !validityTerms {
                termsLabel.textColor = .red
                termsCheckbox.layer.borderColor = UIColor.red.cgColor
            }
            
            self.signUpButton.isEnabled = false
        }
        
        // Set up the animation view
     
    }
    
    
    
    @objc func userNameTextFieldChanged(_ textField: UITextField) {
        self.animationLabel.alpha = 0.0
        self.labelAnimationView.alpha = 0.0
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 0.0
        textField.textColor = .white
        if validityPass && validityUsername && validityFullName && validityEmail && validityTerms {
            self.signUpButton.isEnabled = true
        }
    }
    
    @objc func emailTextFieldEditingEnd(_ textField: UITextField) {
        guard let text = textField.text else {
            updateEmailValidationStatus(false, for: textField)
            return
        }
        
        checkEmailExists(email: text) { emailExists in
            
            if emailExists {
                // Email already exists
                self.updateEmailValidationStatus(false, for: textField)
            } else if self.isEmpty {
                // Email does not exist
                self.updateEmailValidationStatus(false, for: textField)
                print("No email Provided")
            } else {
                self.updateEmailValidationStatus(true, for: textField)
                print("Email Does not exsists")
            }
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == fullNameTextField {
            // Get the current text with the replacement text
            let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            
            if string == " " && currentText.isEmpty {
                // Avoid entering a space as the first character
                return false
            }
            
            let trimmedText = currentText.trimmingCharacters(in: .whitespaces)
            let isValidFullName: Bool
            
            if let lastCharacter = trimmedText.last, lastCharacter == " " {
                // Trim trailing whitespace if the text ends with a space
                textField.text = currentText.trimmingCharacters(in: .whitespaces)
                isValidFullName = false
            } else {
                // Remove multiple spaces between words
                let components = trimmedText.components(separatedBy: .whitespaces)
                let filteredComponents = components.filter { !$0.isEmpty }
                let formattedText = filteredComponents.joined(separator: " ")
                
                // Check if both first name and last name are provided
                let nameComponents = formattedText.components(separatedBy: " ")
                
                if nameComponents.count == 2 {
                    let firstName = nameComponents[0]
                    let lastName = nameComponents[1]
                    
                    // Check for valid number of words and no leading/trailing whitespace
                    isValidFullName = nameComponents.count <= 8 &&
                        !firstName.isEmpty && !lastName.isEmpty &&
                        firstName.count >= 2 && lastName.count >= 2 &&
                        firstName.first!.isLetter && lastName.last!.isLetter
                    
                    // Update the text field's text
                    textField.text = formattedText
                } else {
                    isValidFullName = false
                    textField.text = currentText
                }
            }
            
            return false
        } else {
            // Check for whitespace-only input
            let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            return (newString?.trimmingCharacters(in: .whitespaces) == newString)
            
        }

        
    }

    
    @objc func emailTextFieldChanged(_ textField: UITextField) {
        self.animationLabel3.alpha = 0.0
        self.labelAnimationView3.alpha = 0.0
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 0.0
        textField.textColor = .white
        if validityPass && validityUsername && validityFullName && validityEmail && validityTerms {
            self.signUpButton.isEnabled = true
        }
    }
    
    
    
    
    
    func validateUsername(_ username: String, completion: @escaping (Bool) -> Void) {
        // Check if the username is empty
        guard !username.isEmpty else {
            // Handle the empty username case
            completion(false)
            self.animationLabel.text = "Please Enter a Username"
            return
        }
        
        let regex = "^[a-zA-Z0-9_]+$"
        let usernamePredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        if !usernamePredicate.evaluate(with: username) {
            self.animationLabel.text = "Special Characters Not Allowed"
            completion(usernamePredicate.evaluate(with: username))
            return
        }
        
        let lowercaseUsername = username.lowercased()
        let collectionRef = Firestore.firestore().collection("users").document("usersDetails").collection(lowercaseUsername)
        
        collectionRef.getDocuments { (snapshot, error) in
            if let error = error {
                // Handle the error
                print("Error checking collection: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if let snapshot = snapshot, !snapshot.isEmpty {
                // Collection exists for the username
                print("user name found")
                self.animationLabel.text = "Username Already Exsists"
                completion(false)
            } else {
                // Collection does not exist for the username
                print("user name not found")
                completion(true)
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
    

    func saveUserData(username: String, password: String, email: String, fullName: String, image: UIImage) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                return
            }
            
            guard let uid = authResult?.user.uid else {
                print("Failed to retrieve user ID")
                return
            }
            
            let db = Firestore.firestore()
            let collectionRef = db.collection("users").document("usersDetails").collection(username)
            let documentRef = collectionRef.document("userData")
            
            let userDocument = [
                "username": username,
                "password": password,
                "email": email,
                "fullName": fullName
                // Add more fields as needed
            ]
            
            // Convert the UIImage to Data
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                print("Failed to convert image to data")
                return
            }
            
            documentRef.setData(userDocument) { (error) in
                if let error = error {
                    print("Error saving user data: \(error.localizedDescription)")
                    return
                }
                
                // Upload image to Firebase Storage and associate it with the user's document
                let storageRef = Storage.storage().reference().child("images/\(username).jpg")
                storageRef.putData(imageData, metadata: nil) { (_, error) in
                    if let error = error {
                        print("Error uploading image: \(error.localizedDescription)")
                        return
                    }
                    
                    print("User data and image uploaded successfully")
                }
            }
        }
    }

    
    func checkEmailExists(email: String, completion: @escaping (Bool) -> Void) {
        
        guard !email.isEmpty else {
            // Handle the empty username case
            self.isEmpty = true
            completion(false)
            self.animationLabel3.text = "Please Enter a Email"
            return
        }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if !emailPredicate.evaluate(with: email) {
            self.animationLabel3.text = "Email Incorrect"
            completion(emailPredicate.evaluate(with: email))
            return
        }
        
        self.isEmpty = false
        
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
                    self.animationLabel3.text = "Email Already Exsists"
                } else {
                    // Handle empty signInMethods array
                    completion(false)
                }
            }
        }
    }
    
    @objc private func profileImageTapped() {
        // Handle tap gesture on profile image
        requestPhotoLibraryAccess()
    }
    
    @objc private func profileButtonTapped() {
        // Handle tap gesture on profile button
        if isImageSelected {
               // Remove selected image
            profileImageView.image = UIImage(systemName: "person.circle.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
               profileImageView.contentMode = .scaleAspectFit
               isImageSelected = false
           } else {
               // Handle tap gesture on profile button
               requestPhotoLibraryAccess()
           }
    }
    
    @objc private func signInButtonTapped() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    let window = UIWindow(windowScene: windowScene)
                    let vc = LoginViewController()
                    // Set the window property of the target view controller
                    vc.window = window
            vc.seen = true
                    // Present the target view controller
                    window.rootViewController = vc
                    window.makeKeyAndVisible()
                }
    }
    
    func updateValidationStatus(_ isValid: Bool, for textField: UITextField) {
        if isValid {
            // Valid email format or username, remove the validation UI
            textField.layer.borderColor = UIColor.clear.cgColor
            textField.textColor = .white
            textField.layer.borderWidth = 0.0
            self.animationLabel.alpha = 0.0
            self.labelAnimationView.alpha = 0.0
            self.validityUsername = true
            if validityPass && validityUsername && validityFullName && validityEmail && validityTerms {
                self.signUpButton.isEnabled = true
            }
           
        } else {
            // Invalid email format or username, show the validation UI
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.borderWidth = 1.0
            self.signUpButton.isEnabled = false
            self.validityUsername = false
            textField.textColor = .red
            self.labelAnimationView.alpha = 1.0
            self.animationLabel.alpha = 1.0
            LoginViewController.shakeTextField(textField)
            
           
        }
    }
    
    func updateFullNameValidationStatus(_ isValid: Bool, for textField: UITextField) {
        if isValid {
            // Valid email format or username, remove the validation UI
            textField.layer.borderColor = UIColor.clear.cgColor
            textField.textColor = .white
            textField.layer.borderWidth = 0.0
            self.animationLabel4.alpha = 0.0
            self.labelAnimationView4.alpha = 0.0
            self.validityFullName = true
            if validityPass && validityUsername && validityFullName && validityEmail && validityTerms {
                self.signUpButton.isEnabled = true
            }
           
        } else {
            // Invalid email format or username, show the validation UI
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.borderWidth = 1.0
            self.signUpButton.isEnabled = false
            self.validityFullName = false
            textField.textColor = .red
            self.labelAnimationView4.alpha = 1.0
            self.animationLabel4.alpha = 1.0
            LoginViewController.shakeTextField(textField)
            
           
        }
    }
    
    func updateEmailValidationStatus(_ isValid: Bool, for textField: UITextField) {
        if isValid {
            // Valid email format or username, remove the validation UI
            textField.layer.borderColor = UIColor.clear.cgColor
            textField.textColor = .white
            textField.layer.borderWidth = 0.0
            self.animationLabel3.alpha = 0.0
            self.labelAnimationView3.alpha = 0.0
            self.validityEmail = true
            if validityPass && validityUsername && validityFullName && validityEmail && validityTerms {
                self.signUpButton.isEnabled = true
            }
           
        } else {
            // Invalid email format or username, show the validation UI
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.borderWidth = 1.0
            self.signUpButton.isEnabled = false
            self.validityEmail = false
            textField.textColor = .red
            self.labelAnimationView3.alpha = 1.0
            self.animationLabel3.alpha = 1.0
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
            if validityPass && validityUsername && validityFullName && validityEmail && validityTerms {
                self.signUpButton.isEnabled = true
            }
        } else {
            // Invalid email format or username, show the validation UI
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.borderWidth = 1.0
            textField.textColor = .red
            self.labelAnimationView2.alpha = 1.0
            self.signUpButton.isEnabled = false
            self.validityPass = false
            self.animationLabel2.alpha = 1.0
            LoginViewController.shakeTextField(textField)
            
          
        }
    }
    
    
    
    @objc private func checkBoxTapped() {
        usernameTextField.resignFirstResponder()
           fullNameTextField.resignFirstResponder()
           emailTextField.resignFirstResponder()
           passwordTextField.resignFirstResponder()
        termsCheckbox.isSelected.toggle()
        let termsImageView =  termsCheckbox.isSelected ? UIImage(systemName: "checkmark") : UIImage(systemName: "")
        termsCheckbox.setImage(termsImageView?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        
        if termsCheckbox.isSelected {
            termsLabel.textColor = .gray
            termsCheckbox.backgroundColor = .white
            termsCheckbox.layer.borderColor = UIColor.white.cgColor
            self.validityTerms = termsCheckbox.isSelected
            termsCheckbox.resignFirstResponder()
        } else {
            termsLabel.textColor = .red
            termsCheckbox.layer.borderColor = UIColor.red.cgColor
            self.signUpButton.isEnabled = false
        }
         
        self.validityTerms = termsCheckbox.isSelected
        print ("\(validityPass),\(validityUsername),\(validityFullName),\(validityEmail), \(validityTerms)")
        
        if validityPass && validityUsername && validityFullName && validityEmail && validityTerms   {
            self.signUpButton.isEnabled = true
        }
        
        
    }
    
    private func showImagePicker() {
        
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }

        // Image picker delegate methods
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let selectedImage = info[.editedImage] as? UIImage {
                profileImageView.image = selectedImage
                profileImageView.contentMode = .scaleAspectFill
                isImageSelected = true
            }
            picker.dismiss(animated: true, completion: nil)
        }
    
    func requestPhotoLibraryAccess() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    self.showImagePicker()
                       }
                print("Photo library access granted")
            case .denied, .restricted:
                // Access denied or restricted, handle accordingly
                print("Photo library access denied")
            case .notDetermined:
                // User hasn't made a decision yet, handle accordingly
                print("Photo library access not determined")
            @unknown default:
                // Handle future cases if necessary
                break
            }
        }
    }

    
    @objc func handleSwipeGesture(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: view)
        if gesture.state == .ended && translation.x > 160 {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        let window = UIWindow(windowScene: windowScene)
                        let vc = LoginViewController()
                vc.seen = true
                        // Set the window property of the target view controller
                        vc.window = window
                        
                        // Present the target view controller
                        window.rootViewController = vc
                        window.makeKeyAndVisible()
                    }
        }
    }
}


