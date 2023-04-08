//
//  ColorSpectrumView.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 11.02.2023.
//

import UIKit
//import Foundation

class ColorSpectrumView: UIView {

    var delegate: ColorObserver?
    
    private var image: UIImage!
    
    open var selectedColor:UIColor!
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 10
        
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
        let context = UIGraphicsGetCurrentContext()
        colorGradient.render(in: context!)
        blackGradient.render(in: context!)
        whiteGradient.render(in: context!)
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        layer.addSublayer(colorGradient)
        layer.addSublayer(whiteGradient)
        layer.addSublayer(blackGradient)
    }
    
    
    
    // MARK: - Touches
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        <#code#>
//    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        guard location.x >= 0 && location.y >= 0 else { return }
        guard location.x <= image.size.width && location.y <= image.size.height else { return }
        selectedColor = image.getPixelColor(atLocation: location, withFrameSize: self.frame.size)
        delegate?.colorChanged()
    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let location = touches.first?.location(in: self) else { return }
//        guard location.x >= 0 && location.y >= 0 else { return }
//        selectedColor = image.pixelColor(atLocation: location)
//        delegate?.colorChanged()
//    }
    
    
    
    
    private lazy var whiteGradient: CAGradientLayer = {
        let colors = [
            UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor,
            UIColor(red: 1, green: 1, blue: 1, alpha: 0.01).cgColor,
            UIColor(red: 1, green: 1, blue: 1, alpha: 0.04).cgColor,
            UIColor(red: 1, green: 1, blue: 1, alpha: 0.08).cgColor,
            UIColor(red: 1, green: 1, blue: 1, alpha: 0.15).cgColor,
            UIColor(red: 1, green: 1, blue: 1, alpha: 0.23).cgColor,
            UIColor(red: 1, green: 1, blue: 1, alpha: 0.33).cgColor,
            UIColor(red: 1, green: 1, blue: 1, alpha: 0.44).cgColor,
            UIColor(red: 1, green: 1, blue: 1, alpha: 0.56).cgColor,
            UIColor(red: 1, green: 1, blue: 1, alpha: 0.67).cgColor,
            UIColor(red: 1, green: 1, blue: 1, alpha: 0.77).cgColor,
            UIColor(red: 1, green: 1, blue: 1, alpha: 0.85).cgColor,
            UIColor(red: 1, green: 1, blue: 1, alpha: 0.92).cgColor,
            UIColor(red: 1, green: 1, blue: 1, alpha: 0.96).cgColor,
            UIColor(red: 1, green: 1, blue: 1, alpha: 0.99).cgColor,
            UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
          ]
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.locations = [0, 0.07, 0.13, 0.2, 0.27, 0.33, 0.4, 0.47, 0.53, 0.6, 0.67, 0.73, 0.8, 0.87, 0.93, 1]
        gradientLayer.startPoint = CGPoint(x: 0.30, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.type = .axial
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = 10
        
        return gradientLayer
    }()
    
    private lazy var blackGradient: CAGradientLayer = {
        let colors = [
            UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.99).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.96).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.92).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.85).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.77).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.67).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.56).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.44).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.33).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.23).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.04).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.01).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        ]
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.locations = [0, 0.07, 0.13, 0.2, 0.27, 0.33, 0.4, 0.47, 0.53, 0.6, 0.67, 0.73, 0.8, 0.87, 0.93, 1]
        gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.70, y: 0.5)
        gradientLayer.type = .axial
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = 10
        
        return gradientLayer
    }()
    
    private lazy var colorGradient: CAGradientLayer = {
        let colors = [
            UIColor(red: 0.996, green: 0.02, blue: 0, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.243, blue: 0, alpha: 1).cgColor,
            UIColor(red: 0.996, green: 0.859, blue: 0.008, alpha: 1).cgColor,
            UIColor(red: 0.902, green: 1, blue: 0.039, alpha: 1).cgColor,
            UIColor(red: 0.286, green: 0.992, blue: 0, alpha: 1).cgColor,
            UIColor(red: 0.008, green: 1, blue: 0, alpha: 1).cgColor,
            UIColor(red: 0.102, green: 0.988, blue: 0.251, alpha: 1).cgColor,
            UIColor(red: 0, green: 1, blue: 0.867, alpha: 1).cgColor,
            UIColor(red: 0, green: 0.878, blue: 1, alpha: 1).cgColor,
            UIColor(red: 0, green: 0.267, blue: 1, alpha: 1).cgColor,
            UIColor(red: 0, green: 0, blue: 0.996, alpha: 1).cgColor,
            UIColor(red: 0.255, green: 0, blue: 0.996, alpha: 1).cgColor,
            UIColor(red: 0.878, green: 0.008, blue: 1, alpha: 1).cgColor,
            UIColor(red: 0.996, green: 0, blue: 0.875, alpha: 1).cgColor,
            UIColor(red: 0.992, green: 0.043, blue: 0.263, alpha: 1).cgColor,
            UIColor(red: 0.992, green: 0, blue: 0.012, alpha: 1).cgColor
        ]
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.locations = [0, 0.07, 0.13, 0.2, 0.27, 0.33, 0.4, 0.47, 0.53, 0.6, 0.67, 0.73, 0.8, 0.87, 0.93, 1]
        gradientLayer.type = .axial
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = 10
        
        return gradientLayer
    }()
}
