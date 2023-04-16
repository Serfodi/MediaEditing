//
//  ColorGradientSlider.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 31.01.2023.
//

import UIKit


extension UIView {
    
    var snapshot: UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let capturedImage = renderer.image { context in
            layer.render(in: context.cgContext)
        }
        return capturedImage
    }
}


class ColorGradientSlider: UISlider {
    
    var thumbViewColor = CGColor(gray: 1, alpha: 1)
    
    private let thumbView = {
        let view = ThumbRingView(frame: .init(x: 0, y: 0, width: 36, height: 36))
        view.layer.cornerRadius = 18
        return view
    }()
    
    
    private let trackLayer = CAGradientLayer()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setup()
    }
    
    open func colorsGradient(_ closure: (CGFloat)-> CGColor) {
        var colors:[CGColor] = []
        let countColorGradient = 2
        let stepColor = 1.0 / CGFloat(countColorGradient - 1)
        for n in 0...(countColorGradient - 1) { colors.append(closure(stepColor * CGFloat(n))) }
        trackLayer.colors = colors
        setNeedsDisplay()
    }
    
    open func colorSetThumbView(_ color: CGColor) {
        thumbView.color = color
        setNeedsDisplay()
    }
    
    private func setup() {
        clear()
        createThumbImageView()
        configureTrackLayer()
    }
    
    private func clear() {
        tintColor = .clear
        maximumTrackTintColor = .clear
        backgroundColor = .clear
        thumbTintColor = .clear
    }
    
    private func configureTrackLayer() {
        trackLayer.masksToBounds = true
        trackLayer.startPoint = .init(x: 0, y: 0.5)
        trackLayer.endPoint = .init(x: 1, y: 0.5)
        trackLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        trackLayer.cornerRadius = trackLayer.frame.height / 2
        layer.insertSublayer(trackLayer, at: 0)
    }
    
    private func createThumbImageView() {
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


final class ThumbRingView: UIView {
    
    var view = UIView()
    
    var color: CGColor = CGColor(gray: 0, alpha: 1) {
        didSet {
            view.layer.borderColor = color
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        view.frame =  CGRect(x: 3.5, y: 3.5, width: frame.width - 7, height: frame.height - 7)
        view.backgroundColor = .clear
        view.layer.borderWidth = 3
        view.layer.cornerRadius = view.frame.height / 2
        view.layer.borderColor = color
        addSubview(view)
    }
}

