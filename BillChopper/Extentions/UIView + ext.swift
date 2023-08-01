import UIKit

extension UIView {
    func rotateWithAnimation(angle: CGFloat, duration: CGFloat? = nil) {
        let pathAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        pathAnimation.duration = CFTimeInterval(duration ?? 2.0)
        pathAnimation.fromValue = 0
        pathAnimation.toValue = angle
        pathAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        self.transform = transform.rotated(by: angle)
        self.layer.add(pathAnimation, forKey: "transform.rotation.z")
    }
}
