import UIKit


class ProfileIcon: UIView {
    var internalUIImageView: UIImageView?
    var shapeLayer: CAShapeLayer?
    var image: UIImage? { didSet { setupView() } }
    
    required init(profileImage: UIImage?) {
        super.init(frame: .zero)
        self.image = profileImage
        setupView()
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        internalUIImageView = UIImageView()
        self.addSubview(internalUIImageView!)
        let padding: CGFloat = 1
        
        internalUIImageView?.translatesAutoresizingMaskIntoConstraints = false
        internalUIImageView?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding).isActive = true
        internalUIImageView?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding).isActive = true
        internalUIImageView?.topAnchor.constraint(equalTo: self.topAnchor, constant: padding).isActive = true
        internalUIImageView?.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding).isActive = true
        internalUIImageView?.image = image
        shapeLayer = CAShapeLayer()
    }
    
    override func draw(_ rect: CGRect) {
        drawRingFittingInsideSquareView()
    }
    
    internal func drawRingFittingInsideSquareView() {
        let midPoint: CGFloat = bounds.size.width/2
        let lineWidth: CGFloat = 2
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: midPoint, y: midPoint),
            radius: CGFloat(midPoint - (lineWidth/2)),
            startAngle: CGFloat(0),
            endAngle: CGFloat(Double.pi * 2),
            clockwise: true
        )
        if let sl = shapeLayer {
            sl.path = circlePath.cgPath
            sl.fillColor = UIColor.clear.cgColor
            sl.strokeColor = UIColor.lightGray.cgColor
            sl.lineWidth = lineWidth
            layer.addSublayer(sl)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
        shapeLayer?.removeFromSuperlayer()
        drawRingFittingInsideSquareView()
        guard let imgView = self.internalUIImageView else {return}
        imgView.layer.cornerRadius = imgView.frame.size.height / 2
        imgView.clipsToBounds = true
    }
}
