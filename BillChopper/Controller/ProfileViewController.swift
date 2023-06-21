import UIKit

final class ProfileViewController: UIViewController {
    
    var appUser: AppUser? = nil
    
    private var iconView = ProfileIcon().setUpIconView()
    
    var isPhoneInput = true
    var isImageChanged = false
    
    private lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.isUserInteractionEnabled = true
        let tapOnZoomedIconGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(handleTapOnZoomedIcon)
        )
        coverView.addGestureRecognizer(tapOnZoomedIconGestureRecognizer)
        
        return coverView
    }()
    
    private var uploadButton: UIButton = {
        let uploadButton = UIButton()
        uploadButton.setTitle(R.string.profileView.uploadButtonTitle(), for: .normal)
        uploadButton.setTitleColor(.systemBlue, for: .normal)
        uploadButton.addTarget(self, action: #selector(handleUploadButtonClicked), for: .touchDown)
        
        return uploadButton
    }()
    
    private var saveButton: UIButton = {
        // TODO: use already existing save button
        let saveButton = UIButton()
        
        saveButton.backgroundColor = UIColor(
            hue: 0/360, saturation: 0/100, brightness: 98/100, alpha: 1.0
        )
        saveButton.layer.borderWidth = 1
        saveButton.layer.cornerRadius = 15
        saveButton.setTitle(R.string.profileView.saveButtonTitle(), for: .normal )
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.addTarget(self, action: #selector(handleSaveButtonClicked), for: .touchDown)
        
        return saveButton
    }()
    
    private lazy var usernameTextField: CustomTextField = {
        let usernameTextField = CustomTextField()
        usernameTextField.text = appUser?.username
        usernameTextField.textColor = .black
        usernameTextField.textAlignment = .center
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
    
    private var usernameHelpText: UILabel = {
        let usernameHelpTextLable = UILabel()
        usernameHelpTextLable.text = R.string.profileView.helpText()
        usernameHelpTextLable.font = usernameHelpTextLable.font.withSize(15)
        usernameHelpTextLable.lineBreakMode = .byWordWrapping
        usernameHelpTextLable.numberOfLines = 0
        usernameHelpTextLable.textColor = .black
        
        return usernameHelpTextLable
    }()
    
    private var phoneAndGenderHelpText: UILabel = {
        let usernameHelpTextLable = UILabel()
        usernameHelpTextLable.font = usernameHelpTextLable.font.withSize(15)
        usernameHelpTextLable.lineBreakMode = .byWordWrapping
        usernameHelpTextLable.numberOfLines = 0
        usernameHelpTextLable.textColor = .red
        
        return usernameHelpTextLable
    }()
    
    private let PhoneAndGender: PhoneAndGender = BillChopper.PhoneAndGender()
    
    private let exitButton: UIButton = {
        let button = ExitCross()
        button.addTarget(self, action: #selector(handleExitButtonClicked), for: .touchDown)
        
        return button
    }()
    
    private var isIconZoomed = false
    private var imagePicker: ImagePicker!
    
    private func setWarnings(erros: [String: String]) {
        if let usernameError = erros["username"] {
            usernameHelpText.text = usernameError
        } else {
            usernameHelpText.text = R.string.profileView.helpText()
        }
        if let genderError = erros["gender"] {
            phoneAndGenderHelpText.text = genderError
        } else if let phoneError = erros["phone"] {
            phoneAndGenderHelpText.text = phoneError
        } else {
            phoneAndGenderHelpText.text = ""
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        setupIconView(iconView: iconView)
        addToolbars()
        setupViews()
        addSubviews()
        setUpPhoneField()
        setUpGender()
        if let appUserImage = loadImageFromDiskWith(fileName: "appUser") {
            iconView.image = appUserImage
        }
    }
    
    private func addToolbars() {
        let continueButton = UIBarButtonItem(
            title: "Continue", style: .plain,target: self, action: nil
        )
        
        let codeKeyboardDownButton: UIBarButtonItem = makeKeyboardDownButton()
        let phoneKeyboardDownButton: UIBarButtonItem = makeKeyboardDownButton()
        let usernameKeyboardDownButton: UIBarButtonItem = makeKeyboardDownButton()
        
        continueButton.tintColor = .systemGray
        continueButton.action = #selector(continueTapped)
        
        let CodeKeyboardDownView = codeKeyboardDownButton.customView as? UIButton
        let PhoneKeyboardDownView = phoneKeyboardDownButton.customView as? UIButton
        let usernameKeyboardDownView = usernameKeyboardDownButton.customView as? UIButton
        [CodeKeyboardDownView, PhoneKeyboardDownView, usernameKeyboardDownView
        ].forEach(
            {$0?.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)}
        )
        PhoneAndGender.codeInput.inputAccessoryView = makeToolbar(
            barItems: [codeKeyboardDownButton, flexSpace, continueButton]
        )
        PhoneAndGender.phoneInput.inputAccessoryView = makeToolbar(
            barItems: [phoneKeyboardDownButton, flexSpace]
        )
        usernameTextField.inputAccessoryView = makeToolbar(
            barItems: [usernameKeyboardDownButton, flexSpace]
        )
        
        let phoneAndGenderDelegate = PhoneAndGender.codeInput.delegate as? PhoneInputDelegate
        phoneAndGenderDelegate?.continueButton = continueButton
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
//        if let phoneNum = appUser?.phone {
//            self.rawNumber =
//        }
        usernameTextField.delegate = self
        
        
        let tapOnIconGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(handleTapOnIcon)
        )
        iconView.isUserInteractionEnabled = true
        iconView.addGestureRecognizer(tapOnIconGestureRecognizer)
    }
    
    private func setUpPhoneField() {
        guard let phoneNumber = appUser?.phone,
        let phoneSplit = stripCodeAndPhone(number: phoneNumber) else {
            phoneAndGenderHelpText.text = "feiled to load phone number"
            return
        }
        let code = "+" + phoneSplit.code
        let phone = phoneSplit.phone
        let phoneDelegate = PhoneAndGender.phoneInput.delegate as? PhoneInputDelegate
        
        PhoneAndGender.codeInput.text = code
        phoneDelegate?.insertNumber(num: phone)
        PhoneAndGender.phoneInput.text = formatRawNumber(newRawNumber: phone)
    }
    
    private func setUpGender() {
        guard let isMale = appUser?.isMale else { return }
        PhoneAndGender.genderButton.setTitleColor(.black, for: .normal)
        if isMale {
            PhoneAndGender.genderButton.setTitle(R.string.profileView.male(), for: .normal)
            return
        }
        PhoneAndGender.genderButton.setTitle(R.string.profileView.female(), for: .normal)
    }
    
    private func addSubviews() {
        [exitButton, uploadButton, usernameTextField, usernameHelpText, PhoneAndGender, saveButton, iconView, phoneAndGenderHelpText].forEach({view.addSubview($0)})
    }
    
    @objc func doneButtonTapped() {
            view.endEditing(true)
    }
    
    @objc func continueTapped() {
        PhoneAndGender.phoneInput.becomeFirstResponder()
    }
    
    @objc func handleTapOnIcon() {
        // why do I need selfs here?
        let newDiameter = CGFloat(300)
        iconTopAnchor?.constant = CGFloat(self.view.center.y) - newDiameter / 2
        iconWidthAnchor?.constant = newDiameter
        iconHeigthAnchor?.constant = newDiameter
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
        self.view.addSubview(coverView)
    }
    
    @objc func handleTapOnZoomedIcon() {
        let oldDiameter = CGFloat(150)
        iconTopAnchor?.constant = 50
        iconWidthAnchor?.constant = oldDiameter
        iconHeigthAnchor?.constant = oldDiameter
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
        
        coverView.removeFromSuperview()
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        if isPhoneInput { self.view.frame.origin.y = -150 }
        
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0
    }
    
    private var iconTopAnchor: NSLayoutConstraint?
    private var iconCenterXAnchor: NSLayoutConstraint?
    private var iconWidthAnchor: NSLayoutConstraint?
    private var iconHeigthAnchor: NSLayoutConstraint?
    
    private let iconViewDiameter: CGFloat = 150
    private func setupIconView (iconView: ProfileIcon) {
        iconTopAnchor = iconView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50)
        iconCenterXAnchor = iconView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        iconWidthAnchor = iconView.widthAnchor.constraint(equalToConstant: iconViewDiameter)
        iconHeigthAnchor = iconView.heightAnchor.constraint(equalToConstant: iconViewDiameter)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        [iconView, exitButton, uploadButton, usernameTextField, usernameHelpText, PhoneAndGender,saveButton, phoneAndGenderHelpText].forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        
        let heigthToUploadButton: CGFloat = 50 + iconViewDiameter
        
        let constraints: [NSLayoutConstraint] = [
            iconTopAnchor!,
            iconCenterXAnchor!,
            iconWidthAnchor!,
            iconHeigthAnchor!,
            
            exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            exitButton.widthAnchor.constraint(equalToConstant: 41),
            exitButton.heightAnchor.constraint(equalToConstant: 41),
            
            uploadButton.topAnchor.constraint(equalTo: view.topAnchor, constant: heigthToUploadButton),
            uploadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uploadButton.heightAnchor.constraint(equalToConstant: 40),
            
            usernameTextField.topAnchor.constraint(equalTo: uploadButton.bottomAnchor, constant: 50),
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.heightAnchor.constraint(equalToConstant: 40),
            // TODO: mb change width
            usernameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            usernameHelpText.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 10),
            usernameHelpText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameHelpText.heightAnchor.constraint(equalToConstant: 40),
            usernameHelpText.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor, multiplier: 0.95),
            
            PhoneAndGender.topAnchor.constraint(equalTo: usernameHelpText.bottomAnchor, constant: 50),
            PhoneAndGender.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            PhoneAndGender.heightAnchor.constraint(equalToConstant: 80),
            PhoneAndGender.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor),
            
            phoneAndGenderHelpText.topAnchor.constraint(equalTo: PhoneAndGender.bottomAnchor),
            phoneAndGenderHelpText.widthAnchor.constraint(equalTo: PhoneAndGender.widthAnchor, multiplier: 0.9),
            phoneAndGenderHelpText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            saveButton.widthAnchor.constraint(equalToConstant: 150),
        ]
        NSLayoutConstraint.activate(constraints)
        
        coverView.frame = view.bounds
        usernameTextField.sidePadding = usernameTextField.frame.width * 0.05
        usernameTextField.topPadding = usernameTextField.frame.height * 0.1
    }
    
    @objc func handleUploadButtonClicked(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @objc func handleSaveButtonClicked(_ sender: UIButton) {
        // verify
        let verifier = Verifier()
        let (isValid, validationResult) = Verifier().verifyUserUpdate(
            username: self.usernameTextField.text,
            gender: self.PhoneAndGender.genderButton.titleLabel?.text,
            phone: (self.PhoneAndGender.codeInput.text ?? "") + (self.PhoneAndGender.phoneInput.text ?? "")
        )
        if !isValid {
            setWarnings(erros: validationResult)
            return
        }
        // save to db
        guard let appUser = appUser else { return }//warning?
        appUser.phone = validationResult["username"] ?? appUser.phone
        appUser.username = self.usernameTextField.text
        if validationResult["is_male"] == "True" {
            appUser.isMale = true
        } else {
            appUser.isMale = false
        }
        CoreDataManager.shared.updateAppUser(user: appUser)
        // upload image
        if isImageChanged {
            let filename = "appUser.png"
            uploadImage(fileName: filename, image: iconView.image!)
            saveImage(fileName: "appUser", image: iconView.image!)
        }
        // upload profile updates
        let jsonData = try? JSONSerialization.data(withJSONObject: validationResult)
        var request = setupRequest(url: .updateUser, method: .put, body: jsonData)
        guard let accessToken = KeychainHelper.standard.readToken(
            service: "access-token", account: "backend-auth"
        ) else { return }
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let successHandler = { [unowned self] (data: Data) throws in
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }
        performRequest(request: request, successHandler: successHandler)
    }
    
    @objc func handleExitButtonClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
}


extension ProfileViewController: ImagePickerDelegate, UITextFieldDelegate {
    
    func didSelect(image: UIImage?) {
        guard let image = image else {
            return
        }
        iconView.removeFromSuperview()
        iconView = ProfileIcon().setUpIconView(image)
        setupIconView(iconView: iconView)
        isImageChanged = true
        
        let tapOnIconGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(handleTapOnIcon)
        )
        iconView.isUserInteractionEnabled = true
        iconView.addGestureRecognizer(tapOnIconGestureRecognizer)
        view.addSubview(iconView)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        isPhoneInput = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        isPhoneInput = true
    }
}
