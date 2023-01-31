//
//  ColorPickerButton.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 29.01.2023.
//

import UIKit

@IBDesignable
class ColorPickerButton: UIButton {
    
    
    private let gradientLayer = CAGradientLayer()
    private let colorCircle = CAShapeLayer()
    
    
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
        
        let colors:[CGColor] = [
            CGColor(red: 0.42, green: 0.36, blue: 0.91, alpha: 1),
            CGColor(red: 0.31, green: 0.78, blue: 0.88, alpha: 1),
            CGColor(red: 0.3, green: 0.91, blue: 0.53, alpha: 1),
            CGColor(red: 0.53, green: 0.9, blue: 0.27, alpha: 1),
            CGColor(red: 0.89, green: 0.89, blue: 0.27, alpha: 1),
            CGColor(red: 0.91, green: 0.58, blue: 0.27, alpha: 1),
            CGColor(red: 0.9, green: 0.27, blue: 0.27, alpha: 1),
            CGColor(red: 0.75, green: 0.29, blue: 0.76, alpha: 1)
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.type = .conic
        gradientLayer.colors = colors
        gradientLayer.frame = bounds
        
        let gradientСirclePath = UIBezierPath(ovalIn: bounds)
        let clearCirclePath = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: 3, y: 3), size: CGSize(width: 27, height: 27)))
        gradientСirclePath.append(clearCirclePath)
        
        (gradientLayer.mask as? CAShapeLayer)?.frame = bounds
        (gradientLayer.mask as? CAShapeLayer)?.path = gradientСirclePath.cgPath
        
        
        let colorCirclePath = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: 7, y: 7), size: CGSize(width: 19, height: 19)))
        colorCircle.path = colorCirclePath.cgPath
    }
    
    
    private func setup() {
        backgroundColor = .clear
        gradientLayer.backgroundColor = UIColor.white.cgColor
        
        let mask = CAShapeLayer()
        mask.fillRule = .evenOdd
        gradientLayer.mask = mask
        
        layer.addSublayer(gradientLayer)
        layer.addSublayer(colorCircle)
    }
    
    
    open func colorUpdata(_ color: CGColor) {
        setNeedsDisplay()
        colorCircle.fillColor = color
    }
}
