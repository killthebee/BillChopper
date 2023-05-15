import UIKit

final class PhoneAndGender: UIView {
    
    private let phoneTextLable: UILabel = {
        let lable = UILabel()
        lable.text = R.string.profileView.phoneText()
        lable.textColor = .black
        
        return lable
    }()
    
    private let genderTextLable: UILabel = {
        let lable = UILabel()
        lable.text = R.string.profileView.gender()
        lable.textColor = .black
        
        return lable
    }()
    
    let phoneInput = PhoneInput(isCode: false)
    let codeInput = PhoneInput(isCode: true)
    let phoneInputDelegate = PhoneInputDelegate()
    
    lazy var genderButton: UIButton = {
        let genderButton = UIButton()
        genderButton.setTitle(R.string.profileView.gender(), for: .normal )
        genderButton.setTitleColor(.lightGray, for: .normal)
        genderButton.menu = getGenderMenu()
        genderButton.showsMenuAsPrimaryAction = true
        
        return genderButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        addSubviews()
    }
    
    private func setupViews() {
        phoneInput.delegate = phoneInputDelegate
        codeInput.delegate = phoneInputDelegate
    }
    
    private func addSubviews() {
        self.addSubview(phoneInput)
        self.addSubview(genderButton)
        self.addSubview(phoneTextLable)
        self.addSubview(codeInput)
        self.addSubview(genderTextLable)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = UIColor(
            hue: 0/360, saturation: 0/100, brightness: 98/100, alpha: 1.0
        )
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 15
        addLayer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        phoneTextLable.frame = CGRect(
            x: self.bounds.size.width * 0.03,
            y: 0,
            width: self.bounds.size.width * 0.3,
            height: self.bounds.size.height * 0.5
        )
        phoneInput.frame = CGRect(
            x: self.bounds.size.width * 0.47,
            y: 0,
            width: self.bounds.size.width * 0.6,
            height: self.bounds.size.height * 0.5
        )
        codeInput.frame = CGRect(
            x: self.bounds.size.width * 0.27,
            y: 0,
            width: self.bounds.size.width * 0.18,
            height: self.bounds.size.height * 0.5
        )
        genderTextLable.frame = CGRect(
            x: self.bounds.size.width * 0.03,
            y: self.bounds.size.height * 0.5,
            width: self.bounds.size.width * 0.3,
            height: self.bounds.size.height * 0.5
        )
        genderButton.frame = CGRect(
            x: self.bounds.size.width * 0.3,
            y: self.bounds.size.height * 0.5,
            width: self.bounds.size.width * 0.7,
            height: self.bounds.size.height * 0.5
        )
    }
    
    private func getGenderMenu() -> UIMenu{
        let gender1 = UIAction(title: R.string.profileView.male()) {
            (action) in
            self.genderButton.setTitle(R.string.profileView.male(), for: .normal )
            self.genderButton.setTitleColor(.black, for: .normal)
        }
        let gender2 = UIAction(title: R.string.profileView.female()) {
            (action) in
            self.genderButton.setTitle(R.string.profileView.female(), for: .normal )
            self.genderButton.setTitleColor(.black, for: .normal)
        }
        
        let menu = UIMenu(
            title: R.string.profileView.gender(),
            options: .displayInline,
            children: [gender1, gender2]
        )
        
        return menu
    }
    
    private func addLayer() {
        let middleLineLayer = CAShapeLayer()
        self.layer.addSublayer(middleLineLayer)
        
        middleLineLayer.strokeColor = UIColor.darkGray.cgColor
        middleLineLayer.fillColor = UIColor.white.cgColor
        middleLineLayer.lineWidth = 1
        middleLineLayer.path = getPath().cgPath
    }
    
    private func getPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(
            x: self.bounds.size.width * 0.03, y: self.bounds.size.height * 0.5
        ))
        path.addLine(to: CGPoint(x: self.bounds.size.width * 0.97, y: self.bounds.size.height * 0.5))
        path.close()
        
        return path
    }
    
}
