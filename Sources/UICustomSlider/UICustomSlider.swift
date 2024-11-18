
import UIKit

public class UICustomSlider: UIView {
    
    //MARK: - Outlets
    
    
    //MARK: - Variables
    private var fillColorView: UIView = UIView()
    private var unFillColorView: UIView = UIView()
    private var gradientLayer:CAGradientLayer = CAGradientLayer()
    private var slider: UISlider = UISlider()
    
    //MARK: - Life Cycle Mthods
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    private func initialize() {
        backgroundColor = .clear
        
        //Setup Backround View
        fillColorView.frame = bounds
        fillColorView.backgroundColor = .blue
        
        
        //Set Gradient Layer
        addGradientLayer()
        addSubview(fillColorView)
        
        //add unfillcolorview
        addUnFillColorView()
        
        //Add Cropper
        addCropper()
        
        //Add slider
        addSlider()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        fillColorView.frame = bounds
        gradientLayer.frame = fillColorView.bounds
        slider.frame = bounds
        updateFrameOfUnfillColorView()
        
        addCropper()
        print("Apply Cropper")
    }
    
    //MARK: - Custom Methods
    private func addSlider() {
        slider.frame = bounds
        slider.tintColor = .clear
        slider.backgroundColor = .clear
        slider.maximumTrackTintColor = .clear
        slider.minimumTrackTintColor = .clear
        slider.minimumValue = 0
        slider.maximumValue = 100
        addSubview(slider)
        
        //Add slider action
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }
    
    private func addUnFillColorView() {
        unFillColorView.frame = bounds
        unFillColorView.backgroundColor = .lightGray
        fillColorView.addSubview(unFillColorView)
    }
    
    private func updateFrameOfUnfillColorView() {
        let value = CGFloat(slider.value) * bounds.width / 100
        print("\(bounds.width) ==> \(value)")
        unFillColorView.frame = CGRect(x: value, y: 0, width: bounds.width-value, height: bounds.height)
    }
    
    private func addGradientLayer() {
        gradientLayer.colors = [UIColor(hex: 0x12B76A).cgColor, UIColor(hex: 0xF79009).cgColor, UIColor(hex: 0xF04438).cgColor]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = bounds
        fillColorView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    var lineSize: CGFloat = 8
    private var curveShift: CGFloat { lineSize*0.70 }
    private func addCropper() {
        let lineMinY: CGFloat = (bounds.height-lineSize)/2
        let lineMaxY: CGFloat = bounds.height-lineMinY
        let lineMinX: CGFloat = (bounds.width-lineSize)/2
        let lineMaxX: CGFloat = bounds.width-lineMinX
        let initPoint: CGPoint = CGPoint(x: 0, y: curveShift)
        
        let path: UIBezierPath = UIBezierPath()
        path.move(to: initPoint)
        
        // LeftPoll Top Curve
        path.addCurve(to: CGPoint(x: lineSize, y: curveShift),
                      controlPoint1: CGPoint(x: 0, y: 0),
                      controlPoint2: CGPoint(x: lineSize, y: 0))
        path.addLine(to: CGPoint(x: lineSize, y: lineMinY))
        
        //TopLine between left and center poll
        path.addLine(to: CGPoint(x: lineMinX, y: lineMinY))
        
        //MidPoll Top Curve
        path.addLine(to: CGPoint(x: lineMinX, y: curveShift))
        path.addCurve(to: CGPoint(x: lineMaxX, y: curveShift),
                      controlPoint1: CGPoint(x: lineMinX, y: 0),
                      controlPoint2: CGPoint(x: lineMaxX, y: 0))
        path.addLine(to: CGPoint(x: lineMaxX, y: lineMinY))
        
        //TopLine between cente and right poll
        path.addLine(to: CGPoint(x: bounds.width-lineSize, y: lineMinY))
        
        //Right Top Poll
        path.addLine(to: CGPoint(x: bounds.width-lineSize, y: curveShift))
        path.addCurve(to: CGPoint(x: bounds.width, y: curveShift),
                      controlPoint1: CGPoint(x: bounds.width-lineSize, y: 0),
                      controlPoint2: CGPoint(x: bounds.width, y: 0))
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height-curveShift))
        
        //Right Bottom Poll
        path.addCurve(to: CGPoint(x: bounds.width-lineSize, y: bounds.height-curveShift),
                      controlPoint1: CGPoint(x: bounds.width, y:bounds.height),
                      controlPoint2: CGPoint(x: bounds.width-lineSize, y: bounds.height))
        path.addLine(to: CGPoint(x: bounds.width-lineSize, y: lineMaxY))
        
        //bottom line between center and right poll
        path.addLine(to: CGPoint(x: lineMaxX, y: lineMaxY))
        
        //cetner bottom pall
        path.addLine(to: CGPoint(x: lineMaxX, y: bounds.height-curveShift))
        path.addCurve(to: CGPoint(x: lineMinX, y: bounds.height-curveShift),
                      controlPoint1: CGPoint(x: lineMaxX, y:bounds.height),
                      controlPoint2: CGPoint(x: lineMinX, y: bounds.height))
        path.addLine(to: CGPoint(x: lineMinX, y: lineMaxY))
        
        //bottom line between left and center poll
        path.addLine(to: CGPoint(x: lineSize, y: lineMaxY))
        
        // left bottom pall
        path.addLine(to: CGPoint(x: lineSize, y: bounds.height-curveShift))
        path.addCurve(to: CGPoint(x: 0, y: bounds.height-curveShift),
                      controlPoint1: CGPoint(x: lineSize, y:bounds.height),
                      controlPoint2: CGPoint(x: 0, y: bounds.height))
        
        path.addLine(to: initPoint)
        path.close()
        
        // Mask Layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        fillColorView.layer.mask = shapeLayer
    }
    
    //MARK: - Action Methods
    @objc func sliderValueChanged(_ sender: UISlider) {
        updateFrameOfUnfillColorView()
    }
}
