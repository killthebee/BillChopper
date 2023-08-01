import UIKit

class CustomTextField: UITextField {
    
    public var sidePadding: CGFloat = 10
    public var topPadding: CGFloat = 8

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(
            x: bounds.origin.x + self.sidePadding,
            y: bounds.origin.y + self.topPadding,
            width: bounds.size.width - self.sidePadding * 2,
            height: bounds.size.height - self.topPadding * 2
        )
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
}
