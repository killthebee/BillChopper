import UIKit


final class ProfileViewController: UIViewController {
    //""" Yeah it's "heavely inspired" by tg profile screen
    //"""
    lazy var iconView = setUpIconView()
    lazy var coverView = makeCoverView()
    
    var isIconZoomed = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //naming?
        setupLayout()
        addSubviews()
        addGestures()
    }
    
    private func addSubviews() {
        view.addSubview(iconView)
        
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
    }
    
    private func addGestures() {
        let tapOnIconGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(handleTapOnIcon)
        )
        let tapOnZoomedIconGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(handleTapOnZoomedIcon)
        )
        iconView.isUserInteractionEnabled = true
        iconView.addGestureRecognizer(tapOnIconGestureRecognizer)
        coverView.isUserInteractionEnabled = true
        coverView.addGestureRecognizer(tapOnZoomedIconGestureRecognizer)
    }
    
    private func setUpIconView() -> UIView {
        let profileIcon = ProfileIcon()
        // it's a placeholder!
        profileIcon.image = UIImage(named: "HombreDefault1")
        profileIcon.frame = CGRect(
            x: view.frame.size.width * 0.35,
            y: view.frame.size.height * 0.05,
            width: view.frame.size.width * 0.3,
            height: view.frame.size.width * 0.3
        )
        
        return profileIcon
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
}
