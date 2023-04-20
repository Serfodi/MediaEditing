//
//  ColorGradientSlider.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 31.01.2023.
//

import UIKit


class ColorGradientSlider: UISlider {
    
    private let trackLayer = CAGradientLayer()
    
    private let thumbView = {
        let view = ThumbRingView(frame: .init(x: 0, y: 0, width: 36, height: 36))
        view.layer.cornerRadius = 18
        return view
    }()
    
    
    // MARK: - life cirls
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setup()
    }
    
    
    
    // MARK: - configuration
    
    
    private func setup() {
        clipsToBounds = true
        tintColor = .clear
        maximumTrackTintColor = .clear
        thumbTintColor = .clear
        createThumbImageView()
        configureTrackLayer()
    }
    
    private func configureTrackLayer() {
        trackLayer.masksToBounds = true
        trackLayer.locations = [0, 1]
        trackLayer.startPoint = .init(x: 0.15, y: 0.5)
        trackLayer.endPoint = .init(x: 0.85, y: 0.5)
        trackLayer.frame = bounds
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
    
    
    // MARK: - color
    
    open func colorsGradient(colors: [CGColor]) {
        trackLayer.colors = colors
        setNeedsDisplay()
    }
    
    open func colorSetThumbView(color: UIColor) {
        thumbView.fillColor = color
    }
}



final class ThumbRingView: UIView {
    
    private var view = UIView()
    private var colorLayer = CALayer()
    
    var fillColor = UIColor(white: 1, alpha: 1) {
        didSet {
            colorLayer.backgroundColor = fillColor.cgColor
            setBorderColor()
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
        view.layer.backgroundColor = CGColor(gray: 0, alpha: 1)
        view.layer.borderWidth = 3
        view.layer.cornerRadius = view.frame.height / 2
        view.backgroundColor = .black
        view.clipsToBounds = true
        addSubview(view)
        
        colorLayer.frame = bounds
        view.layer.insertSublayer(colorLayer, at: 0)
    }
    
    private func setBorderColor() {
        var rgba = fillColor.getComponents()
        let _ = rgba.removeLast()
        let isWhiteThember = rgba.contains { component in component > 60 }
        if isWhiteThember {
            view.layer.borderColor = CGColor(gray: 0, alpha: 1)
        } else {
            view.layer.borderColor = CGColor(gray: 0.1, alpha: 1)
        }
    }
    
}

