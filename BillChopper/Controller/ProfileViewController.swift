import UIKit


final class ProfileViewController: UIViewController {
    //""" Yeah it's "heavely inspired" by tg profile screen
    //"""
    // why lazy tho?
    lazy var iconView: ProfileIcon = setUpIconView()
    // TODO: rename func bellow
    lazy var coverView: UIView = makeCoverView()
    lazy var uploadButton: UIButton = setUpUploadButton()
    lazy var saveButton: UIButton = setUpSaveButton()
    // TODO: to lower case, mb change type to custom
    lazy var UsernameTextField: UITextField = setUpUsernameTextField()
    lazy var usernameHelpText: UILabel = setUpUsernameHelpText()
    lazy var PhoneAndGender: UIView = BillChopper.PhoneAndGender()
    
    var isIconZoomed = false
    var imagePicker: ImagePicker!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        //naming?
        addSubviews()
    }
    
    private func addSubviews() {
        view.addSubview(uploadButton)
        view.addSubview(UsernameTextField)
        view.addSubview(usernameHelpText)
        
        // probably I'll make a seperate func what set ups frames for views
        PhoneAndGender.frame = CGRect(
            x: view.frame.size.width * 0.1,
            y: view.frame.size.height * 0.45,
            width: view.frame.size.width * 0.78,
            height: view.frame.size.height * 0.1
        )
        view.addSubview(PhoneAndGender)
        view.addSubview(saveButton)
        // over all other stuff
        view.addSubview(iconView)
    }
    
    private func setUpIconView(_ image: UIImage = UIImage(named: "HombreDefault1")!) -> ProfileIcon {
        let profileIcon = ProfileIcon()
        profileIcon.image = image
        // for the fuck sake stop using width to messure height...
        profileIcon.frame = CGRect(
            x: view.frame.size.width * 0.35,
            y: view.frame.size.height * 0.05,
            width: view.frame.size.width * 0.3,
            height: view.frame.size.width * 0.3
        )
        
        let tapOnIconGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(handleTapOnIcon)
        )
        profileIcon.isUserInteractionEnabled = true
        profileIcon.addGestureRecognizer(tapOnIconGestureRecognizer)
        
        return profileIcon
    }
    
    private func setUpUploadButton() -> UIButton {
        let uploadButton = UIButton(frame: CGRect(
            x: view.frame.size.width * 0.25,
            y: view.frame.size.height * 0.2,
            width: view.frame.size.width * 0.5,
            height: view.frame.size.height * 0.05
        ))
        uploadButton.setTitle("set up profile photo", for: .normal)
        uploadButton.setTitleColor(.systemBlue, for: .normal)
        
        uploadButton.addTarget(self, action: #selector(handleUploadButtonClicked), for: .touchDown)
        return uploadButton
    }
    
    private func setUpUsernameTextField() -> UITextField {
        let usernameTextField = CustomTextField(frame: CGRect(
            x: view.frame.size.width * 0.1,
            y: view.frame.size.height * 0.3,
            width: view.frame.size.width * 0.8,
            height: view.frame.size.height * 0.05
        ))
        usernameTextField.text = "John Dhoe"
        usernameTextField.placeholder = "username"
        usernameTextField.font = UIFont.boldSystemFont(ofSize: 21)
        //usernameTextField.borderStyle = UITextField.BorderStyle.roundedRect
        usernameTextField.autocorrectionType = UITextAutocorrectionType.no
        usernameTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        usernameTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        usernameTextField.keyboardType = UIKeyboardType.default
        usernameTextField.returnKeyType = UIReturnKeyType.done
        usernameTextField.delegate = self
        
        usernameTextField.sidePadding = usernameTextField.frame.width * 0.05
        usernameTextField.topPadding = usernameTextField.frame.height * 0.1
        usernameTextField.layer.borderColor = UIColor.black.cgColor
        usernameTextField.layer.borderWidth = 1
        usernameTextField.layer.cornerRadius = 15
        usernameTextField.backgroundColor = UIColor(
            hue: 0/360, saturation: 0/100, brightness: 98/100, alpha: 1.0
        )
        
        return usernameTextField
    }
    
    private func setUpUsernameHelpText() -> UILabel {
        let usernameHelpTextLable = UILabel(frame: CGRect(
            x: view.frame.size.width * 0.12,
            y: view.frame.size.height * 0.33,
            width: view.frame.size.width * 0.78,
            height: view.frame.size.height * 0.1
        ))
        usernameHelpTextLable.text = "Enter the name other people to see, also an optional profile photo"
        usernameHelpTextLable.font = usernameHelpTextLable.font.withSize(15)
        usernameHelpTextLable.lineBreakMode = .byWordWrapping
        usernameHelpTextLable.numberOfLines = 0
        
        return usernameHelpTextLable
    }
    
    private func setUpSaveButton() -> UIButton {
        let saveButton = UIButton()
        saveButton.frame = CGRect(
            x: view.frame.size.width * 0.25,
            y: view.frame.size.height * 0.6,
            width: view.frame.size.width * 0.5,
            height: view.frame.size.height * 0.05
        )
        saveButton.backgroundColor = UIColor(
            hue: 0/360, saturation: 0/100, brightness: 98/100, alpha: 1.0
        )
        saveButton.layer.borderWidth = 1
        saveButton.layer.cornerRadius = 15
        saveButton.setTitle("save", for: .normal )
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.addTarget(self, action: #selector(handleSaveButtonClicked), for: .touchDown)
        
        return saveButton
    }
    
    private func makeCoverView() -> UIView {
        let coverView = UIView(frame: CGRect(
                x: 0,
                y: 0,
                width: self.view.frame.width,
                height: self.view.frame.height
            )
        )
        
        let tapOnZoomedIconGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(handleTapOnZoomedIcon)
        )
        coverView.isUserInteractionEnabled = true
        coverView.addGestureRecognizer(tapOnZoomedIconGestureRecognizer)
        
        return coverView
    }
    
    @objc func handleTapOnIcon() {
        // why do I need selfs here?
        
        let repositionAnimation = CABasicAnimation(keyPath: "position")
        repositionAnimation.fromValue = self.iconView.center
        repositionAnimation.toValue = self.view.center
        repositionAnimation.duration = 0.5
        repositionAnimation.fillMode = CAMediaTimingFillMode.forwards
        repositionAnimation.isRemovedOnCompletion = false
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1
        scaleAnimation.toValue = 2
        scaleAnimation.duration = 0.5
        scaleAnimation.fillMode = CAMediaTimingFillMode.forwards
        scaleAnimation.isRemovedOnCompletion = false
        
        self.isIconZoomed = true
        self.iconView.layer.add(repositionAnimation, forKey: "iconRePosition")
        self.iconView.layer.add(scaleAnimation, forKey: "iconScale")
        self.view.addSubview(coverView)
    }
    
    @objc func handleTapOnZoomedIcon() {
        if self.isIconZoomed {
            self.iconView.center = self.view.center
            let repositionAnimation = CABasicAnimation(keyPath: "position")
            repositionAnimation.fromValue = self.iconView.center
            repositionAnimation.toValue = CGPoint(
                x: view.frame.size.width * 0.5,
                y: view.frame.size.height * 0.1
            )
            repositionAnimation.duration = 0.5
            repositionAnimation.fillMode = CAMediaTimingFillMode.forwards
            repositionAnimation.isRemovedOnCompletion = false
            
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 2
            scaleAnimation.toValue = 1
            scaleAnimation.duration = 0.5
            scaleAnimation.fillMode = CAMediaTimingFillMode.forwards
            scaleAnimation.isRemovedOnCompletion = false
            
            self.iconView.layer.add(repositionAnimation, forKey: "iconPosition")
            self.iconView.layer.add(scaleAnimation, forKey: "iconDownScale")
            self.isIconZoomed = false
            
            coverView.removeFromSuperview()
            self.iconView.frame = CGRect(
                x: view.frame.size.width * 0.35,
                y: view.frame.size.height * 0.05,
                width: view.frame.size.width * 0.3,
                height: view.frame.size.width * 0.3
            )
        }
    }
    
    @objc func handleUploadButtonClicked(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @objc func handleSaveButtonClicked (_ sender: UIButton) {
        print("save requested")
    }
}


extension ProfileViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        // switching icon views looks kinda twitchy
        guard let image = image else {
            return
        }
        iconView.removeFromSuperview()
        iconView = setUpIconView(image)
        view.addSubview(iconView)
    }
}


extension ProfileViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        print("TextField should return method called")
        // may be useful: textField.resignFirstResponder() textField.text!
        //
        // TODO: validators on the back *ptsd kicks in* but after click on save
        // TODO: save input into model object
        return true
    }
}
