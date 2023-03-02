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
        switch stage {
        case .chooseMethod:
            authContainerBottomHeightConstrain?.isActive = false
            authContainerTopHeightConstrain?.isActive = true
            
            authCoverView.addSubview(authButtonsContainer)
            [signUpButton, signInButton].forEach({authButtonsContainer.addSubview($0)})
            
            NSLayoutConstraint.activate(stage1Constraints)
        case .login:
            [signUpButton, signInButton, authButtonsContainer].forEach({$0.removeFromSuperview()})
//            authButtonsContainer.removeFromSuperview()
            NSLayoutConstraint.deactivate(stage1Constraints)
            [welcomeBackHeaderLable, phoneAndPassword, signUpLable, signInButton, authButtonsContainer
            ].forEach({authCoverView.addSubview($0)})
            authButtonsContainer.addSubview(signInButton)
//            signInButton.removeTarget(self, action: #selector(loginTapped), for: .touchUpInside)
//            signInButton..addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
            NSLayoutConstraint.activate(stage2Constaints)
            
        default:
            break
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        addSubviews()
        addToolbars()
        initialLayoutSetUp(logoContainer: logoContainer)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(rotateTopConrenr))
        logoContainer.addGestureRecognizer(tap)
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
    private var authContainerBottomHeightConstrain: NSLayoutConstraint?
    private var authContainerTopHeightConstrain: NSLayoutConstraint?
    private let authButtonsContainer = UIView()

    private func initialLayoutSetUp(logoContainer: UIView) {
        authContainerBottomHeightConstrain = authCoverView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0)
        authContainerTopHeightConstrain = authCoverView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        authContainerBottomHeightConstrain?.isActive = true
        authContainerTopHeightConstrain?.isActive = false
        logoContainerBottomConstaint = logoContainer.bottomAnchor.constraint(equalTo: authCoverView.topAnchor)
    }
    
    override func viewDidLayoutSubviews() {
        [logoView, logoContainer, topCornerCircleView, bottomCornerCircleView, authCoverView,
         signUpButton, signInButton, authButtonsContainer, phoneAndPassword, welcomeBackHeaderLable,
         signUpLable,
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
        currentStage = .login
        changeStage(stage: .login)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -170
        
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
        } else {
            print("none")
        }
        
    }
}
