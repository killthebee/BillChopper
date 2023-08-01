import UIKit


extension UILabel {
    
    convenience init(frame: CGRect = .zero, text: String, color: UIColor = .black) {
        self.init(frame: frame)
        self.text = text
        self.textColor = color
    }
    
}
