import UIKit


class CustomSlider: UISlider {
    
    @IBInspectable var trackHeight: CGFloat = 3
    
    @IBInspectable var thumbWidth: CGFloat = 20
    
    unowned var selectSplitView: SelectSplitView?
    
    private lazy var thumbView: UIView = {
        let thumb = UIView()
        thumb.backgroundColor = UIColor(red: 0.2627, green: 0.5216, blue: 0.3451, alpha: 1.0)
        thumb.layer.borderWidth = 0.4
        thumb.layer.borderColor = UIColor.darkGray.cgColor
        return thumb
    }()
    
    private func thumbImage(width: CGFloat) -> UIImage {
        thumbView.frame = CGRect(x: 0, y: width / 2, width: width, height: width)
        
        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        return renderer.image { rendererContext in
            thumbView.layer.render(in: rendererContext.cgContext)
        }
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight
        return newRect
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let thumb = thumbImage(width: thumbWidth)
        setThumbImage(thumb, for: .normal)
        setThumbImage(thumb, for: .highlighted)
        self.minimumTrackTintColor = .black
        
        self.minimumValue = 0
        self.maximumValue = 100
        self.setValue(33, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isTracking: Bool {
        selectSplitView?.percent.text = String(format: "%.0f", self.value)
        return true
    }
}
