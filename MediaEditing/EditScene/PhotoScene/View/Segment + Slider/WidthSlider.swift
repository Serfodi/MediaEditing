//
//  WidthSlider.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 01.02.2023.
//

import UIKit


class WidthSlider: UISlider {

    weak var delegate: WidthSliderDelegate?
    
    open var baseLayer = CAShapeLayer()
    open var thumbView = UIView()
    
    private var baseLayerColor = UIColor(white: 1, alpha: 0.1)
    private var slidLayerColor = UIColor(white: 1, alpha: 0.3)
    
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        baseLayer.path = baseLayerPath(frame).cgPath
    }
    
    
    
    
    
    // MARK: - Action
    
    @objc func getValue() {
        delegate?.getValue(value)
    }
    
    
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        delegate?.beginTouchSlider(CGFloat(value))
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        delegate?.endTouchSlider()
    }
    
    
    // MARK: - set
    
    open func setWidthRange(max: Float, min: Float, value: Float) {
        maximumValue = max
        minimumValue = min
        self.value = value
    }
    
    open func setWidthRange(range: ClosedRange<CGFloat>, value: CGFloat) {
        maximumValue = Float(range.upperBound)
        minimumValue = Float(range.lowerBound)
        self.value = Float(value)
    }
    
    
    
    // MARK: - draw
    
    private func baseLayerPath(_ rect: CGRect) -> UIBezierPath {
        
        let minRadius = 2.1
        let maxRadius = 11.5
        
        let point1 = CGPoint(x: minRadius, y: rect.midY - minRadius)
        let point2 = CGPoint(x: rect.width - maxRadius, y: rect.midY - maxRadius)
        let point3 = CGPoint(x: rect.width - maxRadius, y: rect.midY + maxRadius)
        let point4 = CGPoint(x: minRadius, y: rect.midY + minRadius)
        
        return UIBezierPath().roundedRectPath(point1, point2, point3, point4, cornerRadius1: minRadius, cornerRadius2: maxRadius)
    }
    
    
    /// Скрывает базовый слой слайдера
    open func baseLayerHide() {
        setNeedsDisplay()
        baseLayerColor = UIColor.clear
    }
    
    
    /// Возврощаяет прямоугольник рычажка
    open func thumbRect() -> CGRect {
        let trackRect = self.trackRect(forBounds: bounds)
        return self.thumbRect(forBounds: bounds, trackRect: trackRect, value: value)
    }
    
    
    
    
    
    // MARK: - setup
    
    private func setup() {
        clear()
        createBaseLayer()
        createThumbImageView()
        addTarget(self, action: #selector(getValue), for: .allEvents)
    }
    
    private func clear() {
        tintColor = .clear
        maximumTrackTintColor = .clear
        backgroundColor = .clear
        thumbTintColor = .clear
    }
    
    private func createBaseLayer() {
        baseLayer.path = baseLayerPath(frame).cgPath
        baseLayer.fillColor = baseLayerColor.cgColor
        layer.insertSublayer(baseLayer, at: 0)
    }
    
    private func createThumbImageView() {
        thumbView = UIView(frame: .init(x: 0, y: 0, width: frame.height, height: frame.height))
        thumbView.backgroundColor = .white
        thumbView.layer.cornerRadius = thumbView.frame.height / 2
        
        let thumbSnapshot = thumbView.snapshot
        setThumbImage(thumbSnapshot, for: .normal)
        setThumbImage(thumbSnapshot, for: .highlighted)
        setThumbImage(thumbSnapshot, for: .application)
        setThumbImage(thumbSnapshot, for: .disabled)
        setThumbImage(thumbSnapshot, for: .focused)
        setThumbImage(thumbSnapshot, for: .reserved)
        setThumbImage(thumbSnapshot, for: .selected)
    }
}


protocol WidthSliderDelegate: AnyObject {
    
    func getValue(_ value: Float)
    
    func beginTouchSlider(_ width: CGFloat)
    
    func endTouchSlider()
    
}
