//
//  ColorOpacitySlider.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 31.01.2023.
//

import UIKit


class ColorOpacitySlider: UISlider {
    
    
    private let trackLayer = CAGradientLayer()
    
    private let subLayer = CALayer()
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setup()
    }
    
    /// Принимает массив из трех цветов
    open func colorsGradient(_ closure: (Int)-> CGColor) {
        var colors:[CGColor] = []
        for n in 0...1 {colors.append(closure(n))}
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
       
        subLayer.backgroundColor = renderCheckerboardPattern(
            colors: (dark: UIColor.darkGray ,
                     light: UIColor.gray),
            height: frame.height).cgColor
//        subLayer.masksToBounds = true
        subLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        subLayer.cornerRadius = subLayer.frame.height / 2
        
        trackLayer.masksToBounds = true
        trackLayer.startPoint = .init(x: 0, y: 0.5)
        trackLayer.endPoint = .init(x: 1, y: 0.5)
        trackLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        trackLayer.cornerRadius = trackLayer.frame.height / 2
        
        subLayer.addSublayer(trackLayer)
        
        layer.insertSublayer(subLayer, at: 0)
        
    }
    
    
    private func renderCheckerboardPattern(colors: (dark: UIColor, light: UIColor), height:CGFloat) -> UIColor {
        let size = height/3
        let image = UIGraphicsImageRenderer(size: CGSize(width: size * 2, height: size * 2)).image { context in
            colors.dark.setFill()
            context.fill(CGRect(x: 0, y: 0, width: size * 2, height: size * 2))
            colors.light.setFill()
            context.fill(CGRect(x: size, y: 0, width: size, height: size))
            context.fill(CGRect(x: 0, y: size, width: size, height: size))
        }
        return UIColor(patternImage: image)
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


