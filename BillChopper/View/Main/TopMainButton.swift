import UIKit


class TopMainButton: UIButton {
    
    required init(color: UIColor, title: String) {
        super.init(frame: .zero)
        self.backgroundColor = color
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        self.setTitle(title, for: .normal)
        
        self.showsMenuAsPrimaryAction = true
        }

    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
