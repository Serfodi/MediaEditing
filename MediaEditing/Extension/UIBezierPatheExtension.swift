//
//  UIBezierPathExtenshen.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 04.02.2023.
//

import UIKit

extension UIBezierPath {
    
    /**
     * Создает прямоугольник по точкам с закруглеными углами.
     *
     * @param cornerRadius1 закргуления между точкой 1-4
     * @param cornerRadius2 закргуления между точкой 2-3
     */
    func  roundedRectPath(_ point1: CGPoint, _ point2: CGPoint, _ point3: CGPoint, _ point4: CGPoint, cornerRadius1: CGFloat, cornerRadius2: CGFloat) -> UIBezierPath {
        
        let path = UIBezierPath()
        
        /*      1 -- 2
                |    |
                4 -- 3     */
        
        path.move(to: point1)
        path.addCurve(
            to: point2,
            controlPoint1: CGPoint(x: point1.x, y: point1.y),
            controlPoint2: CGPoint(x: point2.x, y: point2.y))
        path.addCurve(
            to: point3,
            controlPoint1: CGPoint(x: point2.x + cornerRadius2 * 5/4, y: point2.y),
            controlPoint2: CGPoint(x: point3.x + cornerRadius2 * 5/4, y: point3.y))
        path.addCurve(
            to: point4,
            controlPoint1: CGPoint(x: point3.x, y: point3.y),
            controlPoint2: CGPoint(x: point4.x, y: point4.y))
        path.addCurve(
            to: point1,
            controlPoint1: CGPoint(x: point4.x - cornerRadius1 * 5/4, y: point4.y),
            controlPoint2: CGPoint(x: point1.x - cornerRadius1 * 5/4, y: point1.y))
        
        return path
    }
    
}
