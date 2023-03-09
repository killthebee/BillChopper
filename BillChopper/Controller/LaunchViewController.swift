import UIKit

class LaunchViewController: UIViewController {

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
        lable.text = ifNewUserText
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
        //usernameTextField.text = "John Dhoe"
        usernameTextField.textColor = .black
        usernameTextField.placeholder = "username"
        usernameTextField.font = UIFont.boldSystemFont(ofSize: 21)
        usernameTextField.autocorrectionType = UITextAutocorrectionType.no
        usernameTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        usernameTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        usernameTextField.keyboardType = UIKeyboardType.default
        usernameTextField.returnKeyType = UIReturnKeyType.done

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
        ]
        switch stage {
        case .chooseMethod:
            authContainerZeroStageHeightConstrain?.isActive = false
            authContainerOneTwoStageHeightConstrain?.isActive = true
            
            authCoverView.addSubview(authButtonsContainer)
            [signUpButton, signInButton].forEach({authButtonsContainer.addSubview($0)})
            
            NSLayoutConstraint.activate(stage1Constraints)
        case .login:
            currentStage = .login
            [signUpButton, signInButton, authButtonsContainer].forEach({$0.removeFromSuperview()})
            NSLayoutConstraint.deactivate(stage1Constraints)
            
            [welcomeBackHeaderLable, phoneAndPassword, signUpLable, signInButton, authButtonsContainer
            ].forEach({authCoverView.addSubview($0)})
            authButtonsContainer.addSubview(signInButton)
            
            NSLayoutConstraint.activate(stage2Constaints)
        case .signup where currentStage == .login:
            currentStage = .signup
            [welcomeBackHeaderLable, phoneAndPassword, signUpLable, signInButton, authButtonsContainer
            ].forEach({$0.removeFromSuperview()})
            NSLayoutConstraint.deactivate(stage2Constaints)
            
            authContainerOneTwoStageHeightConstrain?.isActive = false
            authContainerThreeStageHeightConstrain?.isActive = true
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
            [singUpHeaderContainer, usernameTextField, usernameHelpText, phoneField, phoneContainer, phoneHelpText, passwordAndPassword,
            ].forEach({authCoverView.addSubview($0)})
            phoneField.addSubview(phoneContainer)
            [codeInput, phoneInput].forEach({phoneContainer.addSubview($0)})
            singUpHeaderContainer.addSubview(signUpHeader)
            NSLayoutConstraint.activate(stage3Constraints)
            
        default:
            break
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        setupViews()
        addSubviews()
        addToolbars()
        initialLayoutSetUp(logoContainer: logoContainer)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(rotateTopConrenr))
        logoContainer.addGestureRecognizer(tap)
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
        let continueButton = UIBarButtonItem(
            title: "Continue", style: .plain,target: self, action: nil
        )
        
        let codeKeyboardDownButton: UIBarButtonItem = makeKeyboardDownButton()
        let phoneKeyboardDownButton: UIBarButtonItem = makeKeyboardDownButton()
        let passwordKeyboardDownButton: UIBarButtonItem = makeKeyboardDownButton()
        
        continueButton.tintColor = .systemGray
        continueButton.action = #selector(continueTapped)
        
        let codeKeyboardDownView = codeKeyboardDownButton.customView as? UIButton
        let phoneKeyboardDownView = phoneKeyboardDownButton.customView as? UIButton
        let passwordKeyboardDownView = passwordKeyboardDownButton.customView as? UIButton
        [codeKeyboardDownView, phoneKeyboardDownView, passwordKeyboardDownView
        ].forEach(
            {$0?.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)}
        )
        phoneAndPassword.codeInput.inputAccessoryView = makeToolbar(
            barItems: [codeKeyboardDownButton, flexSpace, continueButton]
        )
        phoneAndPassword.phoneInput.inputAccessoryView = makeToolbar(
            barItems: [phoneKeyboardDownButton, flexSpace]
        )
        phoneAndPassword.passwordInput.inputAccessoryView = makeToolbar(
            barItems: [passwordKeyboardDownButton, flexSpace]
        )
        
        let phoneAndGenderDelegate = phoneAndPassword.codeInput.delegate as? PhoneInputDelegate
        phoneAndGenderDelegate?.continueButton = continueButton
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
         codeInput, phoneInput, phoneContainer, phoneHelpText, passwordAndPassword
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
    
    @objc func rotateTopConrenr() {
        changeStage(stage: .chooseMethod)

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
        if currentStage == .login {
            print("it's time to log user in!")
            return
        }
        changeStage(stage: .login)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = view.frame.maxY > 815 ? -170 : -220
        
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0
    }
    
    @objc func continueTapped() {
        phoneAndPassword.phoneInput.becomeFirstResponder()
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
