//
//  UIColorExtension.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 19.02.2023.
//

import UIKit

extension UIColor {
    
    convenience init(hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat) {
            precondition(0...1 ~= hue &&
                         0...1 ~= saturation &&
                         0...1 ~= lightness &&
                         0...1 ~= alpha, "input range is out of range 0...1")
            
            //From HSL TO HSB ---------
            var newSaturation: CGFloat = 0.0
            
            let brightness = lightness + saturation * min(lightness, 1-lightness)
            if brightness == 0 {
                newSaturation = 0.0
            } else {
                newSaturation = 2 * (1 - lightness / brightness)
            }
            
            self.init(hue: hue, saturation: newSaturation, brightness: brightness, alpha: alpha)
        }
    
}
