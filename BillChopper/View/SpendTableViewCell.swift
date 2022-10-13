import UIKit


class SpendTableViewCell: UITableViewCell {
    static let identifier = "SpendCell"
    static let cellSpacingHeight = CGFloat(5)
    
    private let date: UILabel = basicLable()
    private let month: UILabel = basicLable()
    private let actionIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ActionIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let spendName: UILabel = basicLable()
    private let payeer: UILabel = basicLable()
    private let userAction: UILabel = basicLable()
    private let userBalanceDiff: UILabel = basicLable()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.lightGray
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        
        contentView.addSubview(self.actionIcon)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cellFrame = CGRect(
            x:0,
            y:0,
            width: contentView.frame.width,
            height: 60
        )
        contentView.frame = cellFrame
        
        let actionIconFrame = CGRect(
            x:30,
            y:0,
            width: contentView.frame.width * 0.3,
            height: 60
        )
        self.actionIcon.frame = actionIconFrame
    }
}
