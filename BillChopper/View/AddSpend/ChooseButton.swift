import UIKit

class ChooseButtonView: UIView {
    let chooseEventLable: UILabel = {
        let lable = UILabel()
        lable.textColor = .black
        
        return lable
    }()
    
    let chooseEventImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        
        return imageView
    }()
    
    let chooseButton: UIButton = {
        let button = UIButton()
        button.showsMenuAsPrimaryAction = true
        
        return button
    }()
    
    convenience init(frame: CGRect = .zero, text: String, image: UIImage, menu: UIMenu? = nil) {
        self.init(frame: frame)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 15
        self.addSubview(chooseButton)
        self.addSubview(chooseEventLable)
        self.addSubview(chooseEventImage)
        
        //TODO: guess i'm gonna comment it out soon
        if let menu = menu {
            chooseButton.menu = menu
        } else {
            chooseButton.menu = getChooseMenu()
        }
        chooseEventLable.text = text
        chooseEventImage.image = image
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        chooseButton.frame = self.bounds
        chooseEventLable.frame = CGRect(
            x: bounds.size.width * 0.3,
            y: 0,
            width: bounds.size.width * 0.6,
            height: bounds.size.height
        )
        
        chooseEventImage.frame = CGRect(
            x: bounds.size.width * 0.08,
            y: (bounds.size.height - bounds.size.width * 0.16) / 2,
            width: bounds.size.width * 0.16,
            height: bounds.size.width * 0.16
        )
    }
    
    private func getChooseMenu() -> UIMenu {
        let dummyEvent1 = UIAction(title: "event1", image: UIImage(named: "LentActionIcon")) {
            (action) in
            print("dummy event1")
        }
        let dummyEvent2 = UIAction(title: "event2", image: UIImage(named: "BorrowActionIcon")) {
            (action) in
            print("dummy event2")
        }
        
        let menu = UIMenu(
            title: "events",
            options: .displayInline,
            children: [dummyEvent1, dummyEvent2]
        )
        
        return menu
    }
    
}
