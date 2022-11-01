import UIKit


final class FooterView: UIView {
    
    // TODO: Hide it somewhere else
    let screenRect = UIScreen.main.bounds
    let tenthOfWidnowWidth = UIScreen.main.bounds.width / 10
    let tenthOfWindowHeight = UIScreen.main.bounds.size.height / 10
    
    let plusIcon = UIImage(named:"plusIcon")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addLayer()
        
        let plusIconView = setupPlusIconView()
        //let balanceView = setupBalanceView()
        self.addSubview(plusIconView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addLayer() {
        let shapeLayer = CAShapeLayer()
        self.layer.addSublayer(shapeLayer)
        
        shapeLayer.strokeColor = UIColor.darkGray.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.path = getPath().cgPath
        
    }
    
    private func getPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: tenthOfWindowHeight * 8.5))
        path.addLine(to: CGPoint(x: tenthOfWidnowWidth * 4, y: tenthOfWindowHeight * 8.5))
        path.addArc(
            withCenter: CGPoint(x: tenthOfWidnowWidth * 5, y: tenthOfWindowHeight * 8.5),
            radius: tenthOfWidnowWidth * 1,
            startAngle: .pi,
            endAngle: 0,
            clockwise: true
        )
        path.addLine(to: CGPoint(x: tenthOfWidnowWidth * 10, y: tenthOfWindowHeight * 8.5))
        path.addLine(to: CGPoint(x: tenthOfWidnowWidth * 10, y: tenthOfWindowHeight * 10))
        path.addLine(to: CGPoint(x: 0, y: tenthOfWindowHeight * 10))
        path.addLine(to: CGPoint(x: 0, y: tenthOfWindowHeight * 8.5))
        path.close()
        return path
    }
    
    private func setupPlusIconView() -> UIImageView {
        let iconView = UIImageView()
        iconView.image = plusIcon
        iconView.frame = CGRect(
            x: tenthOfWidnowWidth * 4,
            y: tenthOfWindowHeight * 8,
            width: tenthOfWidnowWidth * 2,
            height: tenthOfWidnowWidth * 2
        )
        iconView.contentMode = .scaleAspectFit
        
        return iconView
    }
}
