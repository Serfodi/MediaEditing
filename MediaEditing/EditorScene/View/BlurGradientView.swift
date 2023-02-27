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
    
    
    // Преоброзования от черного к нужному
    func filteredImage(cgImage: CGImage, size:CGSize) -> UIImage? {
          if let matrixFilter = CIFilter(name: "CIColorMatrix") {
              matrixFilter.setDefaults()
              matrixFilter.setValue(CIImage(cgImage: cgImage), forKey: kCIInputImageKey)
              let rgbVector = CIVector(x: 0, y: 0, z: 0, w: 0)
              let aVector = CIVector(x: 1, y: 1, z: 1, w: 0)
              matrixFilter.setValue(rgbVector, forKey: "inputRVector")
              matrixFilter.setValue(rgbVector, forKey: "inputGVector")
              matrixFilter.setValue(rgbVector, forKey: "inputBVector")
              matrixFilter.setValue(aVector, forKey: "inputAVector")
              matrixFilter.setValue(CIVector(x: 1, y: 1, z: 1, w: 0), forKey: "inputBiasVector")

              if let matrixOutput = matrixFilter.outputImage, let cgImage = CIContext().createCGImage(matrixOutput, from: matrixOutput.extent) {
                  return UIImage(cgImage: cgImage)
              }

          }
          return nil
      }
    
    
    
    

}
