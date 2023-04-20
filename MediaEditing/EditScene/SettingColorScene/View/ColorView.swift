//
//  ColorView.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 17.04.2023.
//

import UIKit

class ColorView: UIView {

    private var colorLayer = CALayer()
    
    var color = UIColor(white: 1, alpha: 1) {
        didSet {
            colorLayer.backgroundColor = color.cgColor
        }
    }
   
    override func draw(_ rect: CGRect) {
        backgroundColor = .black
        clipsToBounds = true
        
        colorLayer.frame = rect
        
        let layer0 = CAShapeLayer()
        
        let pact = UIBezierPath()
        pact.move(to: CGPoint(x: bounds.maxX, y: bounds.minY))
        pact.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        pact.addLine(to: CGPoint(x: bounds.minX, y: bounds.minY))
        pact.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
        
        layer0.path = pact.cgPath
        layer0.frame = bounds
        layer0.backgroundColor = CGColor(gray: 1, alpha: 1)
        
        layer.addSublayer(layer0)
        layer.addSublayer(colorLayer)
    }
    

}
