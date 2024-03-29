import UIKit

final class SaveButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.secondaryLabel
        self.layer.cornerRadius = 15
        self.setTitle(R.string.saveButton.save(), for: .normal)
        self.setTitleColor(.black, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
