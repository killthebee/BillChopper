import UIKit


final class ProfileViewController: UIViewController {
    //""" Yeah it's "heavely inspired" by tg profile screen
    //"""
    lazy var iconView = setUpIconView()
    lazy var coverView: UIView = makeCoverView()
    lazy var uploadButton: UIButton = setUpUploadButton()
    
    var isIconZoomed = false
    var imagePicker: ImagePicker!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        //naming?
        addSubviews()
        addGestures()
    }
    
    private func addSubviews() {
        view.addSubview(uploadButton)
        
        // over all other stuff
        view.addSubview(iconView)
    }
    
    private func addGestures() {
        let tapOnIconGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(handleTapOnIcon)
        )
        let tapOnZoomedIconGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(handleTapOnZoomedIcon)
        )
        // TODO: add swipe up gesture recognizer to coverView
        iconView.isUserInteractionEnabled = true
        iconView.addGestureRecognizer(tapOnIconGestureRecognizer)
        coverView.isUserInteractionEnabled = true
        coverView.addGestureRecognizer(tapOnZoomedIconGestureRecognizer)
    }
    
    private func setUpIconView() -> ProfileIcon {
        let profileIcon = ProfileIcon()
        // it's a placeholder!
        profileIcon.image = UIImage(named: "HombreDefault1")
        // for the fuck sake stop using width to messure height...
        profileIcon.frame = CGRect(
            x: view.frame.size.width * 0.35,
            y: view.frame.size.height * 0.05,
            width: view.frame.size.width * 0.3,
            height: view.frame.size.width * 0.3
        )
        
        return profileIcon
    }
    
    private func setUpUploadButton() -> UIButton {
        let uploadButton = UIButton(frame: CGRect(
            x: view.frame.size.width * 0.3,
            y: view.frame.size.height * 0.2,
            width: view.frame.size.width * 0.4,
            height: view.frame.size.width * 0.1
        ))
        uploadButton.setTitle("set up profile icon", for: .normal)
        uploadButton.setTitleColor(.systemBlue, for: .normal)
        
        uploadButton.addTarget(self, action: #selector(handleUploadButtonClicked), for: .touchDown)
        return uploadButton
    }
    
    private func makeCoverView() -> UIView {
        let coverView = UIView(frame: CGRect(
                x: 0,
                y: 0,
                width: self.view.frame.width,
                height: self.view.frame.height
            )
        )
        return coverView
    }
    
    // TODO: image colletor
    
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
}


extension ProfileViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        print("tap")
        self.iconView.image = image
    }
}
