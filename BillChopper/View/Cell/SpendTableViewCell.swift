import UIKit


class SpendTableViewCell: UITableViewCell {
    static let identifier = "SpendCell"
    static let cellSpacingHeight = CGFloat(5)
    
    let date: UILabel = {
        let lable = UILabel()
        lable.text = "23"
        lable.font = lable.font.withSize(21)
        return lable
    }()
    
    let month: UILabel = {
        let lable = UILabel()
        lable.text = "sep"
        lable.font = lable.font.withSize(13)
        return lable
    }()
    
    let spendName: UILabel = {
        let lable = UILabel()
        lable.text = "dummy (spend)"
        lable.font = UIFont.boldSystemFont(ofSize: 19)
        return lable
    }()
    
    let spendPayeer: UILabel = {
        let lable = UILabel()
        lable.text = "Pavel payed 300$"
        lable.font = lable.font.withSize(15)
        return lable
    }()
    
    let userAction: UILabel = {
        let lable = UILabel()
        lable.text = "you borrowed"
        lable.font = lable.font.withSize(11)
        lable.textAlignment = .right
        lable.textColor = .red
        return lable
    }()
    
    let userBalanceDiff: UILabel = {
        let lable = UILabel()
        lable.text = "1670 usd"
        lable.font = lable.font.withSize(23)
        lable.textAlignment = .right
        lable.textColor = .red
        return lable
    }()
    
    var actionIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BorrowActionIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.white
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        
        contentView.addSubview(spendName)
        contentView.addSubview(spendPayeer)
        contentView.addSubview(userAction)
        contentView.addSubview(userBalanceDiff)
        contentView.addSubview(date)
        contentView.addSubview(month)
        contentView.addSubview(actionIcon)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let frameWidth = contentView.frame.width
        let frameHeight = contentView.frame.height
        
        actionIcon.frame = CGRect(
            x:frameWidth * 0.1,
            y:frameHeight * 0.1,
            width: frameWidth * 0.2,
            height: frameHeight * 0.8
        )
        date.frame = CGRect(
            x: frameWidth * 0.04,
            y: frameHeight * 0.45,
            width: frameWidth * 0.08,
            height: frameHeight * 0.5
        )
        month.frame = CGRect(
            x: frameWidth * 0.04,
            y: 0,
            width: frameWidth * 0.08,
            height: frameHeight * 0.5
        )
        userBalanceDiff.frame = CGRect(
            x: frameWidth * 0.7,
            y: frameHeight * 0.4,
            width: frameWidth * 0.27,
            height: frameHeight * 0.5
        )
        userAction.frame = CGRect(
            x: frameWidth * 0.7,
            y: 0,
            width: frameWidth * 0.27,
            height: frameHeight * 0.5
        )
        spendName.frame = CGRect(
            x: frameWidth * 0.3,
            y: frameHeight * 0.1,
            width: frameWidth * 0.4,
            height: frameHeight * 0.5
        )
        spendPayeer.frame = CGRect(
            x: frameWidth * 0.3,
            y: frameHeight * 0.5,
            width: frameWidth * 0.5,
            height: frameHeight * 0.5
        )
    }
    
}


class LentCell: SpendTableViewCell {
    static let newIdentifier = "LentCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        actionIcon.image = UIImage(named: "LentActionIcon")
        userAction.text = "you owed"
        userAction.textColor = customGreen
        
        userBalanceDiff.text = "1670 usd"
        userBalanceDiff.textAlignment = .right
        userBalanceDiff.textColor = customGreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
