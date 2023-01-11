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
    
    private var PhoneAndGender: UIView = BillChopper.PhoneAndGender()
    
    private let exitButton: UIButton = {
        let button = ExitCross()
        button.addTarget(self, action: #selector(handleExitButtonClicked), for: .touchDown)
        
        return button
    }()
    
    private var isIconZoomed = false
    private var imagePicker: ImagePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        addSubviews()
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
        view.addSubview(PhoneAndGender)
        view.addSubview(saveButton)
        view.addSubview(exitButton)
        view.addSubview(uploadButton)
        view.addSubview(usernameTextField)
        view.addSubview(usernameHelpText)
        view.addSubview(iconView)// over all other stuff
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
        if !self.isIconZoomed { return }
        
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
    
    override func viewDidLayoutSubviews() {
        exitButton.frame = CGRect(
            x: view.bounds.size.width * 0.85,
            y: view.bounds.size.height * 0.05,
            width: view.bounds.size.width * 0.1,
            height: view.bounds.size.width * 0.1
        )
        iconView.frame = CGRect(
            x: view.frame.size.width * 0.35,
            y: view.frame.size.height * 0.05,
            width: view.frame.size.width * 0.3,
            height: view.frame.size.width * 0.3
        )
        coverView.frame = CGRect(
            x: 0,
            y: 0,
            width: self.view.frame.width,
            height: self.view.frame.height
        )
        PhoneAndGender.frame = CGRect(
            x: view.frame.size.width * 0.1,
            y: view.frame.size.height * 0.45,
            width: view.frame.size.width * 0.78,
            height: view.frame.size.height * 0.1
        )
        uploadButton.frame = CGRect(
            x: view.frame.size.width * 0.25,
            y: view.frame.size.height * 0.2,
            width: view.frame.size.width * 0.5,
            height: view.frame.size.height * 0.05
        )
        saveButton.frame = CGRect(
            x: view.frame.size.width * 0.25,
            y: view.frame.size.height * 0.6,
            width: view.frame.size.width * 0.5,
            height: view.frame.size.height * 0.05
        )
        usernameTextField.frame = CGRect(
            x: view.frame.size.width * 0.1,
            y: view.frame.size.height * 0.3,
            width: view.frame.size.width * 0.8,
            height: view.frame.size.height * 0.05
        )
        usernameHelpText.frame = CGRect(
            x: view.frame.size.width * 0.12,
            y: view.frame.size.height * 0.33,
            width: view.frame.size.width * 0.78,
            height: view.frame.size.height * 0.1
        )
        
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
        let tapOnIconGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(handleTapOnIcon)
        )
        iconView.isUserInteractionEnabled = true
        iconView.addGestureRecognizer(tapOnIconGestureRecognizer)
        view.addSubview(iconView)
    }
}
