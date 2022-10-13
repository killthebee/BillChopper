import UIKit


class SpendTableViewCell: UITableViewCell {
    static let identifier = "SpendCell"
    static let cellSpacingHeight = CGFloat(5)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.backgroundColor = UIColor.systemBlue
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        let cellFrame = CGRect(
            x:0,
            y:0,
            width: contentView.frame.width,
            height: 60
        )
        
        contentView.frame = cellFrame
        print(contentView.frame.height)
    }
}
