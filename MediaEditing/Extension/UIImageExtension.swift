//
//  UIImageExtension.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 20.02.2023.
//

import UIKit

extension UIImage {
    
    func getPixelColor(atLocation location: CGPoint, withFrameSize size: CGSize) -> UIColor {
        
//        let x: CGFloat = (self.size.width) * location.x / size.width
//        let y: CGFloat = (self.size.height) * location.y / size.height
        
        let x: CGFloat =  location.x
        let y: CGFloat = location.y
        
        
        let pixelPoint: CGPoint = CGPoint(x: x, y: y)
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelIndex: Int = ( (Int(self.size.width) * Int(pixelPoint.y)) + Int(pixelPoint.x) ) * 8
        
        let r = CGFloat(data[pixelIndex]) / CGFloat(255.0)
        let g = CGFloat(data[pixelIndex+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelIndex+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelIndex+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
}
