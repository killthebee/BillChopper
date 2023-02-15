import UIKit

final class ProfileViewController: UIViewController {
    
    private var iconView = ProfileIcon().setUpIconView()
    
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
    
    private var usernameTextField: CustomTextField = {
        let usernameTextField = CustomTextField()
        usernameTextField.text = "John Dhoe"
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
    
    private var usernameHelpText: UILabel = {
        let usernameHelpTextLable = UILabel()
        usernameHelpTextLable.text = R.string.profileView.helpText()
        usernameHelpTextLable.font = usernameHelpTextLable.font.withSize(15)
        usernameHelpTextLable.lineBreakMode = .byWordWrapping
        usernameHelpTextLable.numberOfLines = 0
        usernameHelpTextLable.textColor = .black
        
        return usernameHelpTextLable
    }()
    
    private var PhoneAndGender: PhoneAndGender = BillChopper.PhoneAndGender()
    
    private let exitButton: UIButton = {
        let button = ExitCross()
        button.addTarget(self, action: #selector(handleExitButtonClicked), for: .touchDown)
        
        return button
    }()
    
    private var isIconZoomed = false
    private var imagePicker: ImagePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
        
        setupIconView(iconView: iconView)
        addToolbars()
        setupViews()
        addSubviews()
    }
    
    private func addToolbars() {
        let continueButton = UIBarButtonItem(
            title: "Continue", style: .plain,target: self, action: nil
        )
        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,target: nil, action: nil
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
        var phoneAndGenderDelegate = PhoneAndGender.codeInput.delegate as? PhoneInputDelegate
        phoneAndGenderDelegate?.continueButton = continueButton
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        usernameTextField.delegate = self
        
        
        let tapOnIconGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(handleTapOnIcon)
        )
        iconView.isUserInteractionEnabled = true
        iconView.addGestureRecognizer(tapOnIconGestureRecognizer)
    }
    
    private func addSubviews() {
        [exitButton, uploadButton, usernameTextField, usernameHelpText, PhoneAndGender, saveButton, iconView].forEach({view.addSubview($0)})
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
        [iconView, exitButton, uploadButton, usernameTextField, usernameHelpText, PhoneAndGender,
         saveButton].forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        
        let heigthToUploadButton: CGFloat = 50 + iconViewDiameter
        
        let  constraints: [NSLayoutConstraint] = [
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
            usernameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            usernameHelpText.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 10),
            usernameHelpText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameHelpText.heightAnchor.constraint(equalToConstant: 40),
            usernameHelpText.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor, multiplier: 0.95),
            
            PhoneAndGender.topAnchor.constraint(equalTo: usernameHelpText.bottomAnchor, constant: 50),
            PhoneAndGender.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            PhoneAndGender.heightAnchor.constraint(equalToConstant: 80),
            PhoneAndGender.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor),
            
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
        print("save requested")
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
}
