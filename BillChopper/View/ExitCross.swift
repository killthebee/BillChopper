import UIKit

class ExitCross: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemGray
        self.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = self.frame.width/2
        addLayer()
    }
    
    private func addLayer() {
        let firstLineLayer = CAShapeLayer()
        self.layer.addSublayer(firstLineLayer)
        
        firstLineLayer.strokeColor = UIColor.white.cgColor
        firstLineLayer.fillColor = UIColor.white.cgColor
        firstLineLayer.lineWidth = 5
        firstLineLayer.path = getFirstLinePath().cgPath
        
        let secondLineLayer = CAShapeLayer()
        self.layer.addSublayer(secondLineLayer)
        
        secondLineLayer.strokeColor = UIColor.white.cgColor
        secondLineLayer.fillColor = UIColor.white.cgColor
        secondLineLayer.lineWidth = 5
        secondLineLayer.path = getSecondLinePath().cgPath
    }
    
    private func getFirstLinePath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(
            x: self.bounds.size.width * 0.3, y: self.bounds.size.height * 0.3
        ))
        path.addLine(to: CGPoint(x: self.bounds.size.width * 0.7, y: self.bounds.size.height * 0.7))
        path.close()
        
        return path
    }
    
    private func getSecondLinePath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(
            x: self.bounds.size.width * 0.7, y: self.bounds.size.height * 0.3
        ))
        path.addLine(to: CGPoint(x: self.bounds.size.width * 0.3, y: self.bounds.size.height * 0.7))
        path.close()
        
        return path
    }
}
