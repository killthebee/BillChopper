import UIKit

final class UserTableViewCell: UITableViewCell {
    static let identifier = "UserTableViewCell"
    
    private lazy var userIconView =  ProfileIcon().setUpIconView()
    
    private let userPhoneLable: UILabel = UILabel(text: "8(800)5353535")
    
    private let userNameLable: UILabel = UILabel(text: "John")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(userPhoneLable)
        contentView.addSubview(userIconView)
        contentView.addSubview(userNameLable)
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
