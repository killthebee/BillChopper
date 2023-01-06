import UIKit


class SplitSelectorViewCell: UITableViewCell {
    static let identifier = "SplitSelectorViewCell"
    
    private let slider = CustomSlider()
    
    private let userNameLable: UILabel = {
        let lable = UILabel()
        // that's a placeholder
        lable.text = "Maximillian"
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
    
    private let userIcon: ProfileIcon = {
        let icon = ProfileIcon()
        // just a placeholder ( move to a configurator in the future )
        icon.image = UIImage(named: "HombreDefault1")
        
        return icon
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        slider.selectSplitView = self
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(percent)
        contentView.addSubview(slider)
        contentView.addSubview(userIcon)
        contentView.addSubview(userNameLable)
    }
    
    override func layoutSubviews() {
        slider.frame = CGRect(
            x: contentView.frame.size.width * 0.4,
            y: 0,
            width: contentView.frame.size.width * 0.4,
            height: contentView.frame.size.height
        )
        percent.frame = CGRect(
            x: contentView.frame.size.width * 0.85,
            y: contentView.frame.size.height * 0.1,
            width: contentView.frame.size.width * 0.15,
            height: contentView.frame.size.height * 0.8
        )
        userIcon.frame = CGRect(
            x: contentView.frame.size.width * 0,
            y: contentView.frame.size.height * 0.1,
            width: contentView.frame.size.height * 0.8,
            height: contentView.frame.size.height  * 0.8
        )
        let remainingWidht = contentView.frame.size.width * 0.45 - contentView.frame.size.height
        userNameLable.frame = CGRect(
            x: contentView.frame.size.height,
            y: 0,
            // that * 0.05 is weird, the text is supposed to have a center alligment
            width: remainingWidht - contentView.frame.size.width * 0.05,
            height: contentView.frame.size.height
        )
    }

}
