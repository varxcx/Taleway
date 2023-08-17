import UIKit
import FirebaseAuth
import Lottie

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    var window: UIWindow?
    private let labelAnimationView = LottieAnimationView(name: "X")
    private let animationLabel = UILabel()
    private var validityEmail = false
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "LogoDiff"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        return imageView
    }()
    
    private let forgotPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Forgot Password?"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        
        let placeholderText =  "Enter your email address"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white, // Replace UIColor.red with your desired color
            .font: UIFont.systemFont(ofSize: 16),
            .shadow: NoInterentAvailableView.createTextShadow()
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        
        textField.attributedPlaceholder = attributedPlaceholder
        textField.layer.cornerRadius = 10
        textField.autocorrectionType = .no
        textField.textColor = .white
        textField.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        textField.alpha = 0
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let forwardButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 40
        button.tintColor = .white
        button.clipsToBounds = true
        button.setBackgroundImage(UIImage(named: "Gradient"), for: .normal)
        button.setImage(UIImage(systemName: "arrow.forward"), for: .normal)
        button.layer.cornerRadius = 30
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .white
        button.alpha = 0.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let color = UIColor(hex: 0x090916) {
            view.backgroundColor = color
        }
        
        let userImageView = UIImageView(image: UIImage(systemName: "envelope.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal))
        let animationContainerView = UIView()
        animationContainerView.addSubview(userImageView)

        // Adjust the frame of the animation container view to add padding
        let padding: CGFloat = 8

        userImageView.frame = CGRect(x: padding, y: 0, width: userImageView.frame.width, height: userImageView.frame.height)
        animationContainerView.frame = CGRect(x: 0, y: 0, width: userImageView.frame.width + padding + 10, height: userImageView.frame.height)

       
        
        // Assign the animation container view as the left view of the text field
        emailTextField.leftView = animationContainerView
        emailTextField.leftViewMode = .always
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
              NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
       
        
        view.addSubview(logoImageView)
        view.addSubview(forgotPasswordLabel)
        view.addSubview(emailTextField)
        view.addSubview(forwardButton)
        view.addSubview(backButton)
        
        let swipeRightGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
            view.addGestureRecognizer(swipeRightGesture)
        
        setupConstraints()
        emailTextField.delegate = self
        forwardButton.addTarget(self, action: #selector(forwardButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        emailTextField.addTarget(self, action: #selector(emailTextFieldEditingEnd(_:)), for: .editingDidEnd)
        emailTextField.addTarget(self, action: #selector(emailTextFieldChanged(_:)), for: .editingChanged)
    }
    
    @objc func emailTextFieldChanged(_ textField: UITextField) {
        self.animationLabel.alpha = 0.0
        self.labelAnimationView.alpha = 0.0
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 0.0
        textField.textColor = .white
        if validityEmail {
            self.forwardButton.isEnabled = true
        }
    }
    
    @objc func emailTextFieldEditingEnd(_ textField: UITextField) {
        guard let text = textField.text else {
            updateEmailValidationStatus(false, for: textField)
            return
        }
        
        

            validateEmail(email: text) { emailExists in
                
                if emailExists {
                    // Email already exists
                    self.updateEmailValidationStatus(true, for: textField)
                } else {
                    self.updateEmailValidationStatus(false, for: textField)
                    print("Email Does not exsists")
                }
            }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.logoImageView.alpha = 1
            self.forgotPasswordLabel.alpha = 1
            self.emailTextField.alpha = 1
            self.forwardButton.alpha = 1
            self.backButton.alpha = 1
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if  validityEmail {
            self.forwardButton.isEnabled = true
            self.forwardButton.sendActions(for: .touchUpInside)
        }
        return true
    }
    
    
    private func setupConstraints() {
          NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
                        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                        logoImageView.widthAnchor.constraint(equalToConstant: 160),
                        logoImageView.heightAnchor.constraint(equalToConstant: 100),
                        
                        forgotPasswordLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
                        forgotPasswordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                        forgotPasswordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                        
                        emailTextField.topAnchor.constraint(equalTo: forgotPasswordLabel.bottomAnchor, constant: 50),
                        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
                        emailTextField.heightAnchor.constraint(equalToConstant: 50),
                        
                        forwardButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
                        forwardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                        forwardButton.widthAnchor.constraint(equalToConstant: 60),
                        forwardButton.heightAnchor.constraint(equalToConstant: 60),
                        
                        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                        backButton.widthAnchor.constraint(equalToConstant: 40),
                        backButton.heightAnchor.constraint(equalToConstant: 40)
            
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
            self.labelAnimationView.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: -5),
            self.labelAnimationView.widthAnchor.constraint(equalToConstant: 40),
            self.labelAnimationView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            self.animationLabel.leadingAnchor.constraint(equalTo: self.labelAnimationView.trailingAnchor, constant: -5),
            self.animationLabel.topAnchor.constraint(equalTo: self.labelAnimationView.topAnchor, constant: 8),
            self.animationLabel.trailingAnchor.constraint(equalTo: self.emailTextField.trailingAnchor, constant: 10),
            self.animationLabel.heightAnchor.constraint(equalToConstant: 15)
        ])

      }
    
    @objc private func forwardButtonTapped() {
        let email = emailTextField.text ?? ""
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
               if let error = error {
                   // Handle the error
                   print("Error sending password reset email: \(error.localizedDescription)")
               } else {
                   // Password reset email sent successfully
                   print("Password reset email sent to \(email)")
                   // Provide appropriate feedback to the user
               }
           }
    }
    
    @objc private func backButtonTapped() {
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
    
    func updateEmailValidationStatus(_ isValid: Bool, for textField: UITextField) {
        if isValid {
            // Valid email format or username, remove the validation UI
            textField.layer.borderColor = UIColor.clear.cgColor
            textField.textColor = .white
            textField.layer.borderWidth = 0.0
            self.animationLabel.alpha = 0.0
            self.labelAnimationView.alpha = 0.0
            self.validityEmail = true
            if validityEmail {
                self.forwardButton.isEnabled = true
            }
           
        } else {
            // Invalid email format or username, show the validation UI
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.borderWidth = 1.0
            self.forwardButton.isEnabled = false
            self.validityEmail = false
            textField.textColor = .red
            self.labelAnimationView.alpha = 1.0
            self.animationLabel.alpha = 1.0
            LoginViewController.shakeTextField(textField)
            
           
        }
    }
    
    @objc func keyboardWillShow(notification: Notification) {
           guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
               return
           }
           
           // Adjust the content view's frame based on the keyboard height
       
       }
       
       @objc func keyboardWillHide(notification: Notification) {
           // Reset the content view's frame when the keyboard is hidden
           view.frame.origin.y = 0
       }
       
       @objc func dismissKeyboard() {
           view.endEditing(true)
       }
}


