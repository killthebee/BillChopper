import UIKit


class UserTableViewCell: UITableViewCell {
    static let identifier = "UserTableViewCell"
    private let userIcon = UIImage(named: "HombreDefault1")
    
    lazy var userIconView: ProfileIcon = {
        let profileIcon = ProfileIcon()
        profileIcon.image = userIcon
        
        return profileIcon
    }()
    
    private let userPhoneLable: UILabel = {
        let lable = UILabel()
        lable.text = "8(800)5353535"
        return lable
    }()
    
    private let userNameLable: UILabel = {
        let lable = UILabel()
        lable.text = "John"
        return lable
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userPhoneLable)
        contentView.addSubview(userIconView)
        contentView.addSubview(userNameLable)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userPhoneLable.frame = CGRect(
            x: contentView.bounds.size.width * 0.2,
            y: 0,
            width: contentView.bounds.size.width * 0.6,
            height: contentView.bounds.size.height
        )
        userIconView.frame = CGRect(
            x: contentView.bounds.size.width * 0.025,
            y: contentView.bounds.size.width * 0.025,
            width: contentView.bounds.size.width * 0.15,
            height: contentView.bounds.size.width * 0.15
        )
        userNameLable.frame = CGRect(
            x: contentView.bounds.size.width * 0.65,
            y: 0,
            width: contentView.bounds.size.width * 0.35,
            height: contentView.bounds.size.height
        )
    }
    
}
