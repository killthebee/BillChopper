import UIKit


struct TileCollectionViewModel {
    let eventTypeName: String
    let eventTypeIcon: UIImage
    var backgroundColor: UIColor
}

class TileCollectionViewCell: UICollectionViewCell {
    static let identifier = "TileCollectionViewCell"
    
    private let eventTypeNameLable: UILabel = {
        let eventTypeNameLable = UILabel()
        eventTypeNameLable.textColor = .black
        eventTypeNameLable.textAlignment = .center
        eventTypeNameLable.font = .systemFont(ofSize: 20, weight: .medium)
        
        return eventTypeNameLable
    }()
    
    private var eventTypeIcon: UIImageView = {
        return UIImageView()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(eventTypeNameLable)
        contentView.addSubview(eventTypeIcon)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        eventTypeNameLable.frame = CGRect(
            x: contentView.bounds.size.width * 0.3,
            y: 0,
            width: contentView.bounds.size.width * 0.6,
            height: contentView.bounds.size.height
        )
        eventTypeIcon.frame = CGRect(
            x: contentView.bounds.size.width * 0.05,
            y: contentView.bounds.size.height * 0.1,
            width: contentView.bounds.size.width * 0.25,
            height: contentView.bounds.size.height * 0.8
        )
        
        
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 1.5
        contentView.layer.borderColor = UIColor.quaternaryLabel.cgColor
        //contentView.backgroundColor = .white
    }
    
    func configure(with viewModel: TileCollectionViewModel) {
        contentView.backgroundColor = viewModel.backgroundColor
        eventTypeNameLable.text = viewModel.eventTypeName
        eventTypeIcon.image = viewModel.eventTypeIcon
    }
    
}
