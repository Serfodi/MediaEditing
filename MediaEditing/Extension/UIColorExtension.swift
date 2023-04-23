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
    

    func getComponents() -> [CGFloat] {
        
        var components: [CGFloat] = []
        
        if let rgb = self.cgColor.components {
            if rgb.count == 2 {
                components = [rgb[0], rgb[0], rgb[0], 1]
            } else {
                components = rgb
            }
        }
        
        return components
    }
    
    
    convenience init?(hex: String) {
        let hexSanitazet = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var rgb: Int64 = 0
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        
        guard Scanner(string: hexSanitazet).scanHexInt64(&rgb) else { return nil }
                
        switch hexSanitazet.count {
        case 3:
            r = CGFloat( (rgb & 0xF00) >> 8 ) / 15.0
            g = CGFloat( (rgb & 0x0F0) >> 4 ) / 15.0
            b = CGFloat( rgb & 0x00F ) / 15.0
        case 6:
            r = CGFloat( (rgb & 0xFF0000) >> 16 ) / 255.0
            g = CGFloat( (rgb & 0x00FF00) >> 8 ) / 255.0
            b = CGFloat( rgb & 0x0000FF ) / 255.0
        default:
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
    
    
    static func hexConvert(red: CGFloat, green: CGFloat, blue: CGFloat) -> String {
        let r = UInt8( red * 255.0 )
        let g = UInt8( green * 255.0 )
        let b = UInt8( blue * 255.0 )
        var rs = String(r, radix: 16, uppercase: true)
        var gs = String(g, radix: 16, uppercase: true)
        var bs = String(b, radix: 16, uppercase: true)
        if rs.count == 1 {
            rs.insert("0", at: rs.startIndex)
        }
        if gs.count == 1 {
            gs.insert("0", at: gs.startIndex)
        }
        if bs.count == 1 {
            bs.insert("0", at: bs.startIndex)
        }
        return rs + gs + bs
    }
    
    
    convenience init?(rgba: [CGFloat]) {
        let r = rgba[0] >= 0 && rgba[0] <= 1
        let g = rgba[1] >= 0 && rgba[1] <= 1
        let b = rgba[2] >= 0 && rgba[2] <= 1
        let a = rgba[3] >= 0 && rgba[3] <= 1
        if r && g && b && a {
            self.init(red: rgba[0], green: rgba[1], blue: rgba[2], alpha: rgba[3])
        } else {
            return nil
        }
    }
    
    
    
}
