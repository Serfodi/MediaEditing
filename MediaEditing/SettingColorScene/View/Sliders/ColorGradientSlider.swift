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
    
    
    private let trackLayer = CAGradientLayer()
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setup()
    }
    
    open func colorsGradient(_ closure: (Int)-> CGColor) {
        var colors:[CGColor] = []
        for n in 0...2 {colors.append(closure(n))}
        setNeedsDisplay()
        trackLayer.colors = colors
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
        let thumbView = ThumbRingView(frame: .init(x: 0, y: 0, width: 36, height: 36))
        thumbView.layer.cornerRadius = 18
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        let view = UIView(frame: CGRect(x: 3.5, y: 3.5, width: frame.width - 7, height: frame.height - 7))
        view.backgroundColor = .clear
        view.layer.cornerRadius = view.frame.height / 2
        view.layer.borderWidth = 3
        view.layer.borderColor = CGColor(gray: 0, alpha: 1)
        addSubview(view)
    }
}

