import UIKit

final class UserTableViewCell: UITableViewCell {
    static let identifier = "UserTableViewCell"
    
    private lazy var userIconView =  ProfileIcon().setUpIconView()
    
    private let userPhoneLable: UILabel = UILabel()
    
    private let usernameLable: UILabel = UILabel(text: "New user")
    
    lazy private var cellStack = UIStackView(
        //arrangedSubviews: [userIconView, usernameLable, userPhoneLable]
    )
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(cellStack)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cellStack.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cellStack.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cellStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cellStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        cellStack.translatesAutoresizingMaskIntoConstraints = false
        cellStack.distribution = .fill
        cellStack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        cellStack.isLayoutMarginsRelativeArrangement = true

        userIconView.translatesAutoresizingMaskIntoConstraints = false
        userIconView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        userIconView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cellStack.addArrangedSubview(userIconView)
        cellStack.setCustomSpacing(5, after: cellStack.arrangedSubviews[0])
        
        usernameLable.translatesAutoresizingMaskIntoConstraints = false
        cellStack.addArrangedSubview(usernameLable)
        
        userPhoneLable.translatesAutoresizingMaskIntoConstraints = false
        userPhoneLable.textAlignment = .center
        cellStack.addArrangedSubview(userPhoneLable)
        userPhoneLable.widthAnchor.constraint(equalTo: cellStack.widthAnchor, multiplier: 0.6).isActive = true
    }
    
    func configure(_ userData: newEventUserProtocol) {
        userPhoneLable.text = userData.phone
        if let username = userData.username {
            usernameLable.text = username != "" ? username : "new User!"
        } else {
            usernameLable.text = "new User!"
        }
        if let image = userData.imageName {
            userIconView.image = UIImage(named: image)
        }
    }
}
