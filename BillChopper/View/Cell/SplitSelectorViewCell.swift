import UIKit

class SplitSelectorViewCell: UITableViewCell {
    static let identifier = "SplitSelectorViewCell"
    
    weak var vcDelegate: AddSpendDelegate?
    
    let slider = CustomSlider()
    
    var phone: String = ""
    
    let userNameLable: UILabel = {
        let lable = UILabel()
        // that's a placeholder
        //lable.text = "Maximillian"
        lable.textAlignment = .center
        lable.textColor = .black
        
        return lable
    }()
    
    let percent: UILabel = {
        let lable = UILabel()
        lable.layer.cornerRadius = 15
        lable.layer.borderWidth = 1
        lable.layer.borderColor = UIColor.black.cgColor
        
        lable.textAlignment = .center
        lable.textColor = .black
        
        return lable
    }()
    
    private var userIcon: ProfileIcon = {
        let icon = ProfileIcon()
        // just a placeholder ( move to a configurator in the future )
        //icon.image = UIImage(named: "HombreDefault1")
        
        return icon
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        slider.selectSplitView = self
        contentView.backgroundColor = .white
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        [percent, slider, userIcon, userNameLable].forEach({contentView.addSubview($0)})
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        [slider, percent, userIcon, userNameLable
        ].forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        let padding: CGFloat = 10
        let constraints: [NSLayoutConstraint] = [
            userIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            userIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            userIcon.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.97),
            userIcon.widthAnchor.constraint(equalTo: userIcon.heightAnchor),
            
            userNameLable.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            userNameLable.leadingAnchor.constraint(equalTo: userIcon.trailingAnchor),
            userNameLable.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            
            percent.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            percent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            percent.widthAnchor.constraint(equalToConstant: 50),
            percent.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.97),
            
            slider.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            slider.leadingAnchor.constraint(equalTo: userNameLable.trailingAnchor),
            slider.trailingAnchor.constraint(equalTo: percent.leadingAnchor, constant: -5),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func configure(_ eventUser: EventUserProtocol, _ delegate: AddSpendDelegate) {
        percent.text = String(eventUser.percent)
        slider.setValue(Float(eventUser.percent), animated: true)
        userIcon.removeFromSuperview()
        userIcon = ProfileIcon(profileImage: eventUser.image)
        contentView.addSubview(userIcon)
        userNameLable.text = eventUser.username
        vcDelegate = delegate
        phone = eventUser.phone
    }
}
