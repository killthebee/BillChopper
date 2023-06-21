import UIKit

class LaunchViewController: UIViewController {
    private lazy var mainViewController = MainViewController()

    enum AuthStages {
        case chooseMethod
        case login
        case signup
    }
    
    private var currentStage: AuthStages = .chooseMethod
    
    private let logoView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.logo3()
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private let topCornerCircleView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.circles2()
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private let authCoverView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        
        return view
    }()
    
    private let bottomCornerCircleView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.circles3()
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle(R.string.launchView.createAccount(), for: .normal)
        button.backgroundColor = .secondaryLabel
        button.layer.cornerRadius = 15
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
        
        return button
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle(R.string.launchView.login(), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        return button
    }()
    
    private let welcomeBackHeaderLable: UILabel = {
        let lable = UILabel(text: R.string.launchView.welcomeBack())
        lable.font = UIFont.boldSystemFont(ofSize: 25)
        lable.textAlignment = .center
        
        return lable
    }()
    
    private let ifNewUserText = R.string.launchView.ifNewUser()
    private let signUpRange = R.string.launchView.singUpRange()
    
    private lazy var signUpLable: UILabel = {
        let lable = UILabel()
        lable.font = lable.font.withSize(15)
        lable.textColor = .black
        
        let underlineAttriString = NSMutableAttributedString(string: ifNewUserText)
        let range1 = (ifNewUserText as NSString).range(of: signUpRange)
        
        underlineAttriString.addAttribute(
            NSAttributedString.Key.foregroundColor, value: customGreen, range: range1
        )
        lable.attributedText = underlineAttriString
        lable.isUserInteractionEnabled = true
        lable.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(switchToSingUp))
        )
        
        return lable
    }()
    
    private let phoneAndPassword = PhoneAndPassword()
    
    private let signUpHeader: UILabel = {
        let lable = UILabel(text: R.string.launchView.signUp())
        lable.font = UIFont.boldSystemFont(ofSize: 25)
        lable.textColor = .black
        lable.textAlignment = .center
        
        return lable
    }()
    
    private var usernameTextField: CustomTextField = {
        // TODO: dry this shit mb
        let usernameTextField = CustomTextField()
        usernameTextField.textColor = .black
        usernameTextField.placeholder = "username"
        usernameTextField.font = UIFont.boldSystemFont(ofSize: 21)
        usernameTextField.autocorrectionType = UITextAutocorrectionType.no
        usernameTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        usernameTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        usernameTextField.keyboardType = UIKeyboardType.default
        usernameTextField.returnKeyType = UIReturnKeyType.done
        usernameTextField.textAlignment = .center

        usernameTextField.layer.borderColor = UIColor.black.cgColor
        usernameTextField.layer.borderWidth = 1
        usernameTextField.layer.cornerRadius = 15
        usernameTextField.backgroundColor = UIColor(
            hue: 0/360, saturation: 0/100, brightness: 98/100, alpha: 1.0
        )

        return usernameTextField
    }()
    
    let codeInput = PhoneInput(isCode: true)
    
    let phoneInput = PhoneInput(isCode: false)
    
    let phoneNumDelegate = PhoneInputDelegate()
    
    private let phoneContainer = UIView()
    
    private let phoneField: UIView = {
        let view = UIView()
        
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 15
        view.backgroundColor = UIColor(
            hue: 0/360, saturation: 0/100, brightness: 98/100, alpha: 1.0
        )
        
        return view
    }()
    
    private var usernameHelpText: UILabel = {
        let usernameHelpTextLable = UILabel()
        usernameHelpTextLable.text = R.string.profileView.helpText()
        usernameHelpTextLable.font = usernameHelpTextLable.font.withSize(15)
        usernameHelpTextLable.lineBreakMode = .byWordWrapping
        usernameHelpTextLable.numberOfLines = 0
        usernameHelpTextLable.textColor = .black
        
        return usernameHelpTextLable
    }()
    
    private var phoneHelpText: UILabel = {
        let usernameHelpTextLable = UILabel()
        usernameHelpTextLable.text = R.string.launchView.phoneHelpText()
        usernameHelpTextLable.font = usernameHelpTextLable.font.withSize(15)
        usernameHelpTextLable.lineBreakMode = .byWordWrapping
        usernameHelpTextLable.numberOfLines = 0
        usernameHelpTextLable.textColor = .black
        
        return usernameHelpTextLable
    }()
    
    private var passwordHelpText: UILabel = {
        let passwordHelpText = UILabel()
        //passwordHelpText.text = "Problems: least one uppercase, least one digit, min 8 characters total"
        passwordHelpText.font = passwordHelpText.font.withSize(15)
        passwordHelpText.lineBreakMode = .byWordWrapping
        passwordHelpText.numberOfLines = 0
        passwordHelpText.textColor = .red
        
        return passwordHelpText
    }()
    
    private let singInErrorHelpText: UILabel = {
        let singInErrorHelpText = UILabel()
//        singInErrorHelpText.text = "No active account found with the given credentials"
        singInErrorHelpText.font = singInErrorHelpText.font.withSize(15)
        singInErrorHelpText.lineBreakMode = .byWordWrapping
        singInErrorHelpText.numberOfLines = 0
        singInErrorHelpText.textColor = .red
        
        return singInErrorHelpText
    }()
    
    private func setWarrings(erros: [String: String]) {
        if let passwordWarning = erros["password"] {
            passwordHelpText.text = passwordWarning
        } else {
            passwordHelpText.text = ""
        }
        if let usernameWarning = erros["username"] {
            usernameHelpText.text = usernameWarning
            usernameHelpText.textColor = .red
        } else {
            usernameHelpText.text = R.string.profileView.helpText()
            usernameHelpText.textColor = .black
        }
        if let phoneWarning = erros["phone"] {
            phoneHelpText.text = phoneWarning
            phoneHelpText.textColor = .red
        } else {
            phoneHelpText.text = R.string.launchView.phoneHelpText()
            phoneHelpText.textColor = .black
        }
    }
    
    private let passwordAndPassword = PasswordAndPassword()
    
    private func changeStage(stage: AuthStages) {
        let stage1Constraints: [NSLayoutConstraint] = [
            authButtonsContainer.centerXAnchor.constraint(equalTo: authCoverView.centerXAnchor),
            authButtonsContainer.centerYAnchor.constraint(equalTo: authCoverView.centerYAnchor),
            authButtonsContainer.widthAnchor.constraint(equalToConstant: 200),
            authButtonsContainer.heightAnchor.constraint(equalToConstant: 135),
            
            signUpButton.topAnchor.constraint(equalTo: authButtonsContainer.topAnchor),
            signUpButton.leadingAnchor.constraint(equalTo: authButtonsContainer.leadingAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: authButtonsContainer.trailingAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            
            signInButton.bottomAnchor.constraint(equalTo: authButtonsContainer.bottomAnchor),
            signInButton.leadingAnchor.constraint(equalTo: authButtonsContainer.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: authButtonsContainer.trailingAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        let stage2Constaints: [NSLayoutConstraint] = [
            phoneAndPassword.centerYAnchor.constraint(equalTo: authCoverView.centerYAnchor),
            phoneAndPassword.centerXAnchor.constraint(equalTo: authCoverView.centerXAnchor),
            phoneAndPassword.widthAnchor.constraint(equalToConstant: 300),
            phoneAndPassword.heightAnchor.constraint(equalToConstant: 80),
            
            singInErrorHelpText.bottomAnchor.constraint(equalTo: phoneAndPassword.topAnchor),
            singInErrorHelpText.widthAnchor.constraint(equalTo: phoneAndPassword.widthAnchor, multiplier: 0.9),
            singInErrorHelpText.centerXAnchor.constraint(equalTo: authCoverView.centerXAnchor),
            
            welcomeBackHeaderLable.topAnchor.constraint(equalTo: authCoverView.topAnchor),
            welcomeBackHeaderLable.bottomAnchor.constraint(equalTo: phoneAndPassword.topAnchor),
            welcomeBackHeaderLable.leadingAnchor.constraint(equalTo: authCoverView.leadingAnchor),
            welcomeBackHeaderLable.trailingAnchor.constraint(equalTo: authCoverView.trailingAnchor),
            
            signUpLable.topAnchor.constraint(equalTo: phoneAndPassword.bottomAnchor),
            signUpLable.heightAnchor.constraint(equalToConstant: 20),
            signUpLable.leadingAnchor.constraint(equalTo: phoneAndPassword.leadingAnchor, constant: 14),
            signUpLable.trailingAnchor.constraint(equalTo: phoneAndPassword.trailingAnchor),
            
            authButtonsContainer.topAnchor.constraint(equalTo: signUpLable.bottomAnchor),
            authButtonsContainer.bottomAnchor.constraint(equalTo: authCoverView.bottomAnchor),
            authButtonsContainer.leadingAnchor.constraint(equalTo: authCoverView.leadingAnchor),
            authButtonsContainer.trailingAnchor.constraint(equalTo: authCoverView.trailingAnchor),
            
            signInButton.centerXAnchor.constraint(equalTo: authButtonsContainer.centerXAnchor),
            signInButton.centerYAnchor.constraint(equalTo: authButtonsContainer.centerYAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            signInButton.widthAnchor.constraint(equalToConstant: 200),
        ]
        let stage3Constraints: [NSLayoutConstraint] = [
            singUpHeaderContainer.topAnchor.constraint(equalTo: authCoverView.topAnchor),
            singUpHeaderContainer.heightAnchor.constraint(equalTo: authCoverView.heightAnchor, multiplier: 0.2),
            singUpHeaderContainer.leadingAnchor.constraint(equalTo: authCoverView.leadingAnchor),
            singUpHeaderContainer.trailingAnchor.constraint(equalTo: authCoverView.trailingAnchor),
            
            signUpHeader.centerXAnchor.constraint(equalTo: singUpHeaderContainer.centerXAnchor),
            signUpHeader.centerYAnchor.constraint(equalTo: singUpHeaderContainer.centerYAnchor),
            //signUpHeader.heightAnchor.constraint(equalToConstant: 50)
            
            usernameTextField.topAnchor.constraint(equalTo: singUpHeaderContainer.bottomAnchor),
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.heightAnchor.constraint(equalToConstant: 40),
            usernameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            usernameHelpText.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 10),
            usernameHelpText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameHelpText.heightAnchor.constraint(equalToConstant: 40),
            usernameHelpText.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor, multiplier: 0.95),
            
            phoneField.topAnchor.constraint(equalTo: usernameHelpText.bottomAnchor, constant: 40),
            phoneField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phoneField.heightAnchor.constraint(equalToConstant: 40),
            phoneField.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor),
            
            phoneContainer.centerXAnchor.constraint(equalTo: phoneField.centerXAnchor),
            phoneContainer.centerYAnchor.constraint(equalTo: phoneField.centerYAnchor),
            phoneContainer.heightAnchor.constraint(equalTo: phoneField.heightAnchor),
            
            codeInput.heightAnchor.constraint(equalTo: phoneContainer.heightAnchor),
            codeInput.leadingAnchor.constraint(equalTo: phoneContainer.leadingAnchor),
            
            phoneInput.leadingAnchor.constraint(equalTo: codeInput.trailingAnchor),
            phoneInput.heightAnchor.constraint(equalTo: phoneContainer.heightAnchor),
            phoneInput.trailingAnchor.constraint(equalTo: phoneContainer.trailingAnchor),
            
            phoneHelpText.topAnchor.constraint(equalTo: phoneContainer.bottomAnchor, constant: 10),
            phoneHelpText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phoneHelpText.heightAnchor.constraint(equalToConstant: 40),
            phoneHelpText.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor, multiplier: 0.95),
            
            passwordAndPassword.topAnchor.constraint(equalTo: phoneHelpText.bottomAnchor, constant: 40),
            passwordAndPassword.centerXAnchor.constraint(equalTo: authCoverView.centerXAnchor),
            passwordAndPassword.widthAnchor.constraint(equalToConstant: 300),
            passwordAndPassword.heightAnchor.constraint(equalToConstant: 80),
            
            passwordHelpText.topAnchor.constraint(equalTo: passwordAndPassword.bottomAnchor),
            passwordHelpText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordHelpText.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor, multiplier: 0.95),
            
            //authButtonsContainer.heightAnchor.constraint(equalTo: authCoverView.heightAnchor, multiplier: 0.3),
            authButtonsContainer.bottomAnchor.constraint(equalTo: authCoverView.bottomAnchor),
            authButtonsContainer.leadingAnchor.constraint(equalTo: authCoverView.leadingAnchor),
            authButtonsContainer.trailingAnchor.constraint(equalTo: authCoverView.trailingAnchor),
//
            signUpButton.centerXAnchor.constraint(equalTo: authButtonsContainer.centerXAnchor),
            signUpButton.centerYAnchor.constraint(equalTo: authButtonsContainer.centerYAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            signUpButton.widthAnchor.constraint(equalToConstant: 200),
        ]
        switch stage {
        case .chooseMethod:
            authContainerZeroStageHeightConstrain?.isActive = false
            authContainerOneTwoStageHeightConstrain?.isActive = true
            
            authCoverView.addSubview(authButtonsContainer)
            [signUpButton, signInButton].forEach({authButtonsContainer.addSubview($0)})
            
            NSLayoutConstraint.activate(stage1Constraints)
        case .login where currentStage == .chooseMethod:
            currentStage = .login
            [signUpButton, signInButton, authButtonsContainer].forEach({$0.removeFromSuperview()})
            NSLayoutConstraint.deactivate(stage1Constraints)
            
            [welcomeBackHeaderLable, phoneAndPassword, signUpLable, signInButton, authButtonsContainer, singInErrorHelpText
            ].forEach({authCoverView.addSubview($0)})
            authButtonsContainer.addSubview(signInButton)
            
            NSLayoutConstraint.activate(stage2Constaints)
        case .signup where currentStage == .login:
            currentStage = .signup
            [welcomeBackHeaderLable, phoneAndPassword, signUpLable, signInButton, authButtonsContainer, singInErrorHelpText
            ].forEach({$0.removeFromSuperview()})
            NSLayoutConstraint.deactivate(stage2Constaints)
            
            authContainerOneTwoStageHeightConstrain?.isActive = false
            authContainerThreeStageHeightConstrain?.isActive = true
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
            [singUpHeaderContainer, usernameTextField, usernameHelpText, phoneField, phoneContainer, phoneHelpText, passwordAndPassword, authButtonsContainer, passwordHelpText
            ].forEach({authCoverView.addSubview($0)})
            authButtonsContainer.addSubview(signUpButton)
            phoneField.addSubview(phoneContainer)
            [codeInput, phoneInput].forEach({phoneContainer.addSubview($0)})
            singUpHeaderContainer.addSubview(signUpHeader)
            
            NSLayoutConstraint.activate(stage3Constraints)
            
        case .signup where currentStage == .chooseMethod:
            currentStage = .signup
            [signUpButton, signInButton, authButtonsContainer].forEach({$0.removeFromSuperview()})
            NSLayoutConstraint.deactivate(stage1Constraints)
            
            authContainerOneTwoStageHeightConstrain?.isActive = false
            authContainerThreeStageHeightConstrain?.isActive = true
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
            [singUpHeaderContainer, usernameTextField, usernameHelpText, phoneField, phoneContainer, phoneHelpText, passwordAndPassword, authButtonsContainer, passwordHelpText
            ].forEach({authCoverView.addSubview($0)})
            authButtonsContainer.addSubview(signUpButton)
            phoneField.addSubview(phoneContainer)
            [codeInput, phoneInput].forEach({phoneContainer.addSubview($0)})
            singUpHeaderContainer.addSubview(signUpHeader)
            
            NSLayoutConstraint.activate(stage3Constraints)
        case .login where currentStage == .signup:
            currentStage = .login
            [singUpHeaderContainer, usernameTextField, usernameHelpText, phoneField,
             phoneContainer, phoneHelpText, passwordAndPassword, authButtonsContainer,
             passwordHelpText].forEach({$0.removeFromSuperview()})
            NSLayoutConstraint.deactivate(stage3Constraints)
            
            authContainerThreeStageHeightConstrain?.isActive = false
            authContainerOneTwoStageHeightConstrain?.isActive = true
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
            
            [welcomeBackHeaderLable, phoneAndPassword, signUpLable, signInButton, authButtonsContainer, singInErrorHelpText
            ].forEach({authCoverView.addSubview($0)})
            authButtonsContainer.addSubview(signInButton)
            
            NSLayoutConstraint.activate(stage2Constaints)
        default:
            break
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        addSubviews()
        self.addToolbars()
        initialLayoutSetUp(logoContainer: logoContainer)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(sender:)),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(sender:)),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
//        KeychainHelper.standard.save(
//            Data("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY4ODAyOTU2MCwianRpIjoiZGYwYzViNTEwOTNiNDQxMzg5OGUwMzkwYTc4YjdjODYiLCJ1c2VyX2lkIjoyfQ.t7OjKs1w9F3tv9ffjyyLah65afa5c_NO_XqluZhos0s".utf8),
//            serice: "refresh-token",
//            account: "backend-auth"
//        )
        
        let refreshSuccessHandler = { [unowned self] (data: Data) throws in
            // TODO: mb catch and launch .chooseMethod stage on main queue
            let responseObject = try JSONDecoder().decode(RefreshSuccess.self, from: data)
            KeychainHelper.standard.save(
                Data(responseObject.access.utf8),
                serice: "access-token",
                account: "backend-auth"
            )
            if let appUser = CoreDataManager.shared.fetchAppUser() {
                DispatchQueue.main.async {
                    self.mainViewController.appUser = appUser
                    self.mainViewController.modalPresentationStyle = .fullScreen
                    self.present(self.mainViewController, animated: false)
                }
            } else {
                DispatchQueue.main.async {
                    self.changeStage(stage: .chooseMethod)
                    UIView.animate(withDuration: 0.67, animations: {
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }
        
        let refreshFailureHandler = { [unowned self] (data: Data) throws in
            DispatchQueue.main.async {
                self.changeStage(stage: .chooseMethod)
                UIView.animate(withDuration: 0.67, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
        if let refreshToken = KeychainHelper.standard.readToken(
            service: "refresh-token", account: "backend-auth"
        ) {
            UIView.animateKeyframes(withDuration: 1, delay: 0, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                    self.topCornerCircleView.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 0.5)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                    self.bottomCornerCircleView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi * 0.5)
                })
            })
            let json: [String: Any] = ["refresh": refreshToken]
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            let request = setupRequest(url: .refresh, method: .post, body: jsonData)
            performRequest(request: request, successHandler: refreshSuccessHandler, failureHandler: refreshFailureHandler)
        } else {
            UIView.animateKeyframes(withDuration: 1, delay: 0, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                    self.topCornerCircleView.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 0.5)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                    self.bottomCornerCircleView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi * 0.5)
                })
            }, completion: { _ in
                self.changeStage(stage: .chooseMethod)
                UIView.animate(withDuration: 0.67, animations: {
                    self.view.layoutIfNeeded()
                })
                
            })
//            setupViews()
//            addSubviews()
//            self.addToolbars()
//            initialLayoutSetUp(logoContainer: logoContainer)
////            self.changeStage(stage: .chooseMethod)
//            let tap = UITapGestureRecognizer(target: self, action: #selector(rotateTopCorner))
//            logoContainer.addGestureRecognizer(tap)
//            return
        }
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
//
//        setupViews()
//        addSubviews()
////        addToolbars()
//        initialLayoutSetUp(logoContainer: logoContainer)
//        let tap = UITapGestureRecognizer(target: self, action: #selector(rotateTopCorner))
//        logoContainer.addGestureRecognizer(tap)
    }
    
    private func setupViews() {
        [codeInput, phoneInput].forEach({$0.delegate = phoneNumDelegate})
    }
    
    private func addSubviews() {
        [logoContainer, topCornerCircleView, bottomCornerCircleView, authCoverView,
        ].forEach({view.addSubview($0)})
        logoContainer.addSubview(logoView)
    }
    
    private func addToolbars() {
        let loginContinueButton = UIBarButtonItem(
            title: "Continue", style: .plain,target: self, action: nil
        )
        let signupContinueButton = UIBarButtonItem(
            title: "Continue", style: .plain,target: self, action: nil
        )
        
        let loginCodeKeyboardDownButton: UIBarButtonItem = makeKeyboardDownButton()
        let loginPhoneKeyboardDownButton: UIBarButtonItem = makeKeyboardDownButton()
        let loginPasswordKeyboardDownButton: UIBarButtonItem = makeKeyboardDownButton()
        let usernameKeyboardDownButton: UIBarButtonItem = makeKeyboardDownButton()
        let signupCodeKeyboardDownButton: UIBarButtonItem = makeKeyboardDownButton()
        let signupPhoneKeyboardDownButton: UIBarButtonItem = makeKeyboardDownButton()
        let signupPasswordKeyboardDownButton: UIBarButtonItem = makeKeyboardDownButton()
        let signupRepeatPasswordKeyboardDownButton: UIBarButtonItem = makeKeyboardDownButton()
        
        loginContinueButton.tintColor = .systemGray
        loginContinueButton.action = #selector(continueTapped)
        signupContinueButton.tintColor = .systemGray
        signupContinueButton.action = #selector(continueTapped)
        
        let loginCodeKeyboardDownView = loginCodeKeyboardDownButton.customView as? UIButton
        let loginPhoneKeyboardDownView = loginPhoneKeyboardDownButton.customView as? UIButton
        let loginPasswordKeyboardDownView = loginPasswordKeyboardDownButton.customView as? UIButton
        let usernameKeyboardDownView = usernameKeyboardDownButton.customView as? UIButton
        let signupCodeKeyboardDownView = signupCodeKeyboardDownButton.customView as? UIButton
        let signupPhoneKeyboardDownView = signupPhoneKeyboardDownButton.customView as? UIButton
        let signupPasswordKeyboardDownView = signupPasswordKeyboardDownButton.customView as? UIButton
        let signupRepeatPasswordKeyboardDownView = signupRepeatPasswordKeyboardDownButton.customView as? UIButton
        [loginCodeKeyboardDownView, loginPhoneKeyboardDownView, loginPasswordKeyboardDownView, usernameKeyboardDownView, signupCodeKeyboardDownView, signupPhoneKeyboardDownView,
         signupRepeatPasswordKeyboardDownView, signupPasswordKeyboardDownView,
        ].forEach(
            {$0?.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)}
        )
        phoneAndPassword.codeInput.inputAccessoryView = makeToolbar(
            barItems: [loginCodeKeyboardDownButton, flexSpace, loginContinueButton]
        )
        phoneAndPassword.phoneInput.inputAccessoryView = makeToolbar(
            barItems: [loginPhoneKeyboardDownButton, flexSpace]
        )
        phoneAndPassword.passwordInput.inputAccessoryView = makeToolbar(
            barItems: [loginPasswordKeyboardDownButton, flexSpace]
        )
        usernameTextField.inputAccessoryView = makeToolbar(
            barItems: [usernameKeyboardDownButton, flexSpace]
        )
        codeInput.inputAccessoryView = makeToolbar(
            barItems: [signupCodeKeyboardDownButton, flexSpace, signupContinueButton]
        )
        phoneInput.inputAccessoryView = makeToolbar(
            barItems: [signupPhoneKeyboardDownButton, flexSpace]
        )
        passwordAndPassword.passwordInput.inputAccessoryView = makeToolbar(
            barItems: [signupPasswordKeyboardDownButton, flexSpace]
        )
        passwordAndPassword.repeatPasswordInput.inputAccessoryView = makeToolbar(
            barItems: [signupRepeatPasswordKeyboardDownButton, flexSpace]
        )
        
        let phoneAndGenderDelegate = phoneAndPassword.codeInput.delegate as? PhoneInputDelegate
        phoneAndGenderDelegate?.continueButton = loginContinueButton
        let signupPhoneDeledate = phoneInput.delegate as? PhoneInputDelegate
        signupPhoneDeledate?.continueButton = signupContinueButton
    }
    
    private let logoContainer = UIView()
    private var logoContainerBottomConstaint: NSLayoutConstraint?
    private var authContainerZeroStageHeightConstrain: NSLayoutConstraint?
    private var authContainerOneTwoStageHeightConstrain: NSLayoutConstraint?
    private var authContainerThreeStageHeightConstrain: NSLayoutConstraint?
    private let authButtonsContainer = UIView()
    
    private lazy var singUpHeaderContainer = UIView()

    private func initialLayoutSetUp(logoContainer: UIView) {
        authContainerZeroStageHeightConstrain = authCoverView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0)
        authContainerOneTwoStageHeightConstrain = authCoverView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        authContainerThreeStageHeightConstrain = authCoverView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7)
        
        authContainerZeroStageHeightConstrain?.isActive = true
        authContainerOneTwoStageHeightConstrain?.isActive = false
        authContainerThreeStageHeightConstrain?.isActive = false
        logoContainerBottomConstaint = logoContainer.bottomAnchor.constraint(equalTo: authCoverView.topAnchor)
    }
    
    override func viewDidLayoutSubviews() {
        [logoView, logoContainer, topCornerCircleView, bottomCornerCircleView, authCoverView,
         signUpButton, signInButton, authButtonsContainer, phoneAndPassword, welcomeBackHeaderLable,
         signUpLable, singUpHeaderContainer, signUpHeader, usernameTextField, usernameHelpText, phoneField,
         codeInput, phoneInput, phoneContainer, phoneHelpText, passwordAndPassword, passwordHelpText, singInErrorHelpText
        ].forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        let viewHeight = view.frame.height
        
         
        let constraints: [NSLayoutConstraint] = [
            authCoverView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            authCoverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            authCoverView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            //authContainerHeightConstrain!,
            
            logoContainerBottomConstaint!,
            logoContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            logoContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            logoContainer.topAnchor.constraint(equalTo: view.topAnchor),
            
            logoView.centerYAnchor.constraint(equalTo: logoContainer.centerYAnchor),
            logoView.leadingAnchor.constraint(equalTo: logoContainer.leadingAnchor),
            logoView.trailingAnchor.constraint(equalTo: logoContainer.trailingAnchor),
            
            topCornerCircleView.topAnchor.constraint(equalTo: view.topAnchor, constant: -viewHeight * 0.25),
            topCornerCircleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: viewHeight * 0.26),
            topCornerCircleView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            topCornerCircleView.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            bottomCornerCircleView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: viewHeight * 0.25),
            bottomCornerCircleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -viewHeight * 0.25),
            bottomCornerCircleView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            bottomCornerCircleView.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
        ]
        
//        topCornerCircleView.frame = CGRect(
//            x: view.frame.width * 0.25, y: 0, width: view.frame.width * 0.25, height: view.frame.width * 0.25)
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func rotateTopCorner() {
//        changeStage(stage: .chooseMethod)

        UIView.animateKeyframes(withDuration: 1, delay: 0, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.33, animations: {
                self.topCornerCircleView.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 0.5)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.33, relativeDuration: 0.33, animations: {
                self.bottomCornerCircleView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi * 0.5)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.67, relativeDuration: 0.33, animations: {
                self.view.layoutIfNeeded()
            })
        })
    }
    
    @objc func loginTapped() {
        print(currentStage)
        if currentStage != .login {
            changeStage(stage: .login)
            return
        }
        
        guard let phone = self.phoneInput.text,
              let code = self.codeInput.text
        else {
            self.singInErrorHelpText.text = R.string.addEvent.notProvided()
            return
        }
        
        let verifier = Verifier()
        let cleanPhoneNumber = verifier.stripPhoneNumber(phone: code + phone)
        let isValidPhone = verifier.isValidPhone(phone: cleanPhoneNumber)
//        guard isValidfPhone else {
//            self.singInErrorHelpText.text = R.string.addEvent.phoneNotValid()
//            return
//        }
        let (isValid, validationResult) = Verifier().verifySingIn(
            username:  (phoneAndPassword.codeInput.text ?? "") +  (phoneAndPassword.phoneInput.text ?? ""),
            password: phoneAndPassword.passwordInput.text
        )
        if !isValid {
            self.singInErrorHelpText.text = validationResult["error"]
            return
        }
        
        let userFetchSuccessHandler = { [unowned self] (data: Data) throws in
            let responseObject = try JSONDecoder().decode(UserFetch.self, from: data)
            
            DispatchQueue.main.async {
                guard let appUser = CoreDataManager.shared.createAppUser(
                    username: responseObject.first_name,
                    phone: responseObject.username,
                    isMale: responseObject.profile.is_male
                ) else { return }
                self.mainViewController.appUser = appUser
                
                self.mainViewController.modalPresentationStyle = .fullScreen
                self.present(self.mainViewController, animated: false)
            }
        }
        let signInSuccessHandler = { [weak self] (data: Data) throws in
            let responseObject = try JSONDecoder().decode(LoginSuccess.self, from: data)
            KeychainHelper.standard.save(
                Data(responseObject.access.utf8),
                serice: "access-token",
                account: "backend-auth"
            )
            KeychainHelper.standard.save(
                Data(responseObject.refresh.utf8),
                serice: "refresh-token",
                account: "backend-auth"
            )
            
            // TODO: fetch user data
            // TODO: present main VC
            DispatchQueue.main.async {
//                let json: [String: Any] = ["username": cleanPhoneNumber]
                let json: [String: Any] = ["username": validationResult["username"] ?? ""]
                let jsonData = try? JSONSerialization.data(withJSONObject: json)
                var request = setupRequest(url: .fetchUserData, method: .post, body: jsonData)
                request.setValue("Bearer \(responseObject.access)", forHTTPHeaderField: "Authorization")
                performRequest(
                    request: request,
                    successHandler: userFetchSuccessHandler
                )
            }
        }
            
            
        let signInFailureHandler = { [weak self] (data: Data) throws in
            let responseObject = try JSONDecoder().decode(userFetchError.self, from: data)
            DispatchQueue.main.async {
                self?.singInErrorHelpText.text = responseObject.detail
            }
        }
        print(validationResult)
        let json: [String: Any] = validationResult
        // Un123456
//        let json: [String: Any] = ["username": "admin", "password": "123456"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let request = setupRequest(url: .login, method: .post, body: jsonData)
        performRequest(request: request, successHandler: signInSuccessHandler, failureHandler: signInFailureHandler)
        }
    
    @objc func signupTapped() {
        if currentStage == .signup {
            let signUpSuccessHandler = { [unowned self] (data: Data) throws in
                let responseObject = try JSONDecoder().decode(RegisterationSuccess.self, from: data)
                DispatchQueue.main.async {
                    self.welcomeBackHeaderLable.text = "Time to Login!"
                    self.changeStage(stage: .login)
                    return
                }
            }
            let signUpFailureHandler = { [weak self] (data: Data) throws in
                let responseObject = try JSONDecoder().decode(RegisterError.self, from: data)
                DispatchQueue.main.async {
                    var errors: [String: String] = [:]
                    if let usernameWarning = responseObject.username {
                        errors["username"] = usernameWarning.joined(separator: " ")
                    }
                    if responseObject.password != nil {
                        errors["password"] = "least one uppercase, least one digit, min 8 characters total"
                    }
                    self?.setWarrings(erros: errors)
                }
            }
            let (isValid, validationResult) = Verifier().verifyUserSignUpData(
                username: self.usernameTextField.text ?? "",
                password: self.passwordAndPassword.passwordInput.text ?? "",
                secondPassword: self.passwordAndPassword.repeatPasswordInput.text ?? "",
                phone: (self.codeInput.text ?? "") + (self.phoneInput.text ?? "")
            )

            if !isValid {
                setWarrings(erros: validationResult)
                return
            }
            print(validationResult)
            let json: [String: Any] = validationResult
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            let request = setupRequest(url: .register, method: .post, body: jsonData)
            performRequest(request: request, successHandler: signUpSuccessHandler, failureHandler: signUpFailureHandler)
            return
        }
        changeStage(stage: .signup)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        // keypad for buttom password is covering field
//        self.view.frame.origin.y = view.frame.maxY > 845 ? -170 : -220
        self.view.frame.origin.y = -220
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0
    }
    
    @objc func continueTapped() {
        switch currentStage {
        case .login:
            phoneAndPassword.phoneInput.becomeFirstResponder()
        case .signup:
            phoneInput.becomeFirstResponder()
        default:
            return
        }
    }
    
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
    
    @objc func switchToSingUp(sender:UITapGestureRecognizer) {
        let signUpRange = (ifNewUserText as NSString).range(of: signUpRange)
        if sender.didTapAttributedTextInLabel(label: signUpLable, inRange: signUpRange) {
            print("signup")
            changeStage(stage: .signup)
        } else {
            print("none")
        }
        
    }
}
