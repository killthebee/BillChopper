import UIKit


extension UILabel {
    convenience init(frame: CGRect = .zero, text: String) {
        self.init(frame: frame)
        self.text = text
    }
}
