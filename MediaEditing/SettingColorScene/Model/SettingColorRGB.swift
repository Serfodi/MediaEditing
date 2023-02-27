//
//  SettingColorRGB.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 29.01.2023.
//

import UIKit

struct SettingColorRGB {
    
    var red: CGFloat
    var green: CGFloat
    var blue: CGFloat
    var opacity: CGFloat
    
    var color: UIColor {
        get {
            return UIColor(red: red, green: green, blue: blue, alpha: opacity)
        }
    }
    
}
