import UIKit


class SpendTableViewCell: UITableViewCell {
    static let identifier = "SpendCell"
    static let cellSpacingHeight = CGFloat(5)
    
    private let date: UILabel = basicLable()
    private let month: UILabel = basicLable()
    private var actionIcon: UIImageView!
    private let spendName: UILabel = basicLable()
    private let spendPayeer: UILabel = basicLable()
    let userAction: UILabel = basicLable()
    let userBalanceDiff: UILabel = basicLable()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.white
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        
        self.actionIcon = setupImage()
        
        setupDate()
        setupMonth()
        setupSpendName()
        setupBalanceDiff()
        setupUserAction()
        setupSpendPayeer()
        
        contentView.addSubview(self.spendName)
        contentView.addSubview(self.spendPayeer)
        contentView.addSubview(self.userAction)
        contentView.addSubview(self.userBalanceDiff)
        contentView.addSubview(self.date)
        contentView.addSubview(self.month)
        contentView.addSubview(self.actionIcon)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupImage() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BorrowActionIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let frameWidth = contentView.frame.width
        let frameHeight = contentView.frame.height
        
        let cellFrame = CGRect(
            x:0,
            y:0,
            width: frameWidth,
            height: frameHeight + frameHeight * 0.2
        )
        contentView.frame = cellFrame
        
        let actionIconFrame = CGRect(
            x:frameWidth * 0.1,
            y:frameHeight * 1.2 * 0.1,
            width: contentView.frame.width * 0.2,
            height: (frameHeight + frameHeight * 0.2) * 0.8
        )
        
        let dateFrame = CGRect(
            x: frameWidth * 0.04,
            y: frameHeight * 1.2 * 0.4,
            width: frameWidth * 0.08,
            height: (frameHeight + frameHeight * 0.2) * 0.5
        )
        
        let monthFrame = CGRect(
            x: frameWidth * 0.04,
            y: 0,
            width: frameWidth * 0.08,
            height: (frameHeight + frameHeight * 0.2) * 0.5
        )
        
        let balanceDiffFrame = CGRect(
            x: frameWidth * 0.7,
            y: frameHeight * 1.2 * 0.4,
            width: frameWidth * 0.27,
            height: (frameHeight + frameHeight * 0.2) * 0.5
        )
        
        let userActionFrame = CGRect(
            x: frameWidth * 0.7,
            y: 0,
            width: frameWidth * 0.27,
            height: (frameHeight + frameHeight * 0.2) * 0.5
        )
        
        let spendNameFrame = CGRect(
            x: frameWidth * 0.3,
            y: frameHeight * 1.2 * 0.1,
            width: frameWidth * 0.4,
            height: (frameHeight + frameHeight * 0.2) * 0.5
        )
        
        let spendPayeerFrame = CGRect(
            x: frameWidth * 0.3,
            y: frameHeight * 1.2 * 0.5,
            width: frameWidth * 0.5,
            height: (frameHeight + frameHeight * 0.2) * 0.5
        )
        
        self.spendPayeer.frame = spendPayeerFrame
        self.spendName.frame = spendNameFrame
        self.userAction.frame = userActionFrame
        self.userBalanceDiff.frame = balanceDiffFrame
        self.month.frame = monthFrame
        self.date.frame = dateFrame
        self.actionIcon.frame = actionIconFrame
    }
    
    private func setupDate(){
        self.date.text = "23"
        self.date.font = self.date.font.withSize(21)
    }
    
    private func setupMonth () {
        self.month.text = "sep"
        self.month.font = self.month.font.withSize(13)
    }
    
    private func setupSpendName() {
        self.spendName.text = "dummy (spend)"
        self.spendName.font = UIFont.boldSystemFont(ofSize: 19)
    }
    
    private func setupUserAction() {
        self.userAction.text = "you borrowed"
        self.userAction.font = self.userAction.font.withSize(11)
        self.userAction.textAlignment = .right
        self.userAction.textColor = .red
    }
    
    private func setupBalanceDiff() {
        self.userBalanceDiff.text = "1670 usd"
        self.userBalanceDiff.font = self.userBalanceDiff.font.withSize(23)
        self.userBalanceDiff.textAlignment = .right
        self.userBalanceDiff.textColor = .red
    }
    
    private func setupSpendPayeer() {
        // TODO format string
        self.spendPayeer.text = "Pavel payed 300$"
        self.spendPayeer.font = self.spendPayeer.font.withSize(15)
    }
}


class LentCell: SpendTableViewCell {
    static let newIdentifier = "LentCell"
    private var actionIcon: UIImageView!
    
    private let customGreen: UIColor = UIColor(red: 0.2627, green: 0.5216, blue: 0.3451, alpha: 1.0)
    
    override func setupImage() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LentActionIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    private func setupUserAction() {
        // TODO: make green darker
        self.userAction.text = "you owed"
        self.userAction.font = self.userAction.font.withSize(11)
        self.userAction.textAlignment = .right
        self.userAction.textColor = customGreen
    }
    
    private func setupBalanceDiff() {
        self.userBalanceDiff.text = "1670 usd"
        self.userBalanceDiff.font = self.userBalanceDiff.font.withSize(23)
        self.userBalanceDiff.textAlignment = .right
        self.userBalanceDiff.textColor = customGreen
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.actionIcon = setupImage()
        setupBalanceDiff()
        setupUserAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
