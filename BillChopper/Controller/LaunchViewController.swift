import UIKit

class LaunchViewController: UIViewController {
    
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
    
    private let authContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .red
        
        return view
    }()
    
    private let bottomCornerCircleView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.circles3()
        view.contentMode = .scaleAspectFit
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        initialLayoutSetUp(logoContainer: logoContainer)
        addSubviews()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(rotateTopConrenr))
        view.addGestureRecognizer(tap)
    }
    
    private func addSubviews() {
        [logoContainer, topCornerCircleView, bottomCornerCircleView, authContainer,
        ].forEach({view.addSubview($0)})
        logoContainer.addSubview(logoView)
    }
    
    private let logoContainer = UIView()
    private var logoContainerBottomConstaint: NSLayoutConstraint?
    private var authContainerBottomHeightConstrain: NSLayoutConstraint?
    private var authContainerTopHeightConstrain: NSLayoutConstraint?

    private func initialLayoutSetUp(logoContainer: UIView) {
        authContainerBottomHeightConstrain = authContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0)
        authContainerTopHeightConstrain = authContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        authContainerBottomHeightConstrain?.isActive = true
        logoContainerBottomConstaint = logoContainer.bottomAnchor.constraint(equalToSystemSpacingBelow: authContainer.topAnchor, multiplier: 1)
    }
    
    override func viewDidLayoutSubviews() {
        [logoView, logoContainer, topCornerCircleView, bottomCornerCircleView, authContainer,
        ].forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        let viewHeight = view.frame.height
        
         
        let constraints: [NSLayoutConstraint] = [
            authContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            authContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            authContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
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
//        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
//            self.topCornerCircleView.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 0.5)
//
//        })
        authContainerBottomHeightConstrain?.isActive = false
        authContainerTopHeightConstrain?.isActive = true

        UIView.animateKeyframes(withDuration: 3, delay: 0, animations: {
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
//        let timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(delayedAction), userInfo: nil, repeats: false)
    }
    
    @objc func delayedAction() {
        authContainerBottomHeightConstrain?.isActive = false
        authContainerTopHeightConstrain?.isActive = true
//        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
//            self.bottomCornerCircleView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi * 0.5)
//        }, completion: {
//
//
//        })
        UIView.animateKeyframes(withDuration: 2, delay: 0, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.bottomCornerCircleView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi * 0.5)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        })
    }
}
