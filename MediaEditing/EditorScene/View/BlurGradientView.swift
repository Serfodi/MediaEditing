//
//  BlurGradientView.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 31.01.2023.
//

import UIKit

@IBDesignable
class BlurGradientView: UIView {

    private let bluerView = UIVisualEffectView()
    private let gradientLayer = CAGradientLayer()
    
    @IBInspectable var startLocations: Float {
        set { locationsGradient[0] = newValue as NSNumber }
        get { return Float(truncating: locationsGradient[0]) }
    }
    
    @IBInspectable var endLocations: Float  {
        set { locationsGradient[1] = newValue as NSNumber }
        get { return Float(truncating: locationsGradient[1]) }
    }
    
    var locationsGradient: [NSNumber] = [0, 0]
    
    @IBInspectable var startColor: UIColor {
        set { colors[0] = newValue.cgColor  }
        get { return UIColor(cgColor: colors[0]) }
    }
    
    @IBInspectable var endColor: UIColor {
        set { colors[1] = newValue.cgColor  }
        get { return UIColor(cgColor: colors[1]) }
    }
    
    var colors:[CGColor] = [
        CGColor(red: 0, green: 0, blue: 0, alpha: 1),
        CGColor(red: 0, green: 0, blue: 0, alpha: 0),
    ]
    
    
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
        
        let bluerEffect = UIBlurEffect(style: .dark)
        bluerView.effect = bluerEffect
        bluerView.frame = bounds
        
        gradientLayer.locations = locationsGradient
        gradientLayer.colors = colors
        gradientLayer.frame = bounds
    }
    
    func setup() {
        backgroundColor = .clear
        
//        bluerView.layer.mask = gradientLayer
//        layer.addSublayer(bluerView.layer)
        
        layer.addSublayer(gradientLayer)
    }

}
