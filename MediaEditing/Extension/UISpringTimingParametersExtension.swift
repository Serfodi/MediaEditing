//
//  UISpringTimingParametersExtension.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 18.04.2023.
//

import UIKit

extension UISpringTimingParameters {

    convenience init(damping: CGFloat, response: CGFloat, initialVelocity: CGVector = .zero) {
        let stiffness = pow(2 * .pi / response, 2)
        let damp = 4 * .pi * damping / response
        self.init(mass: 1, stiffness: stiffness, damping: damp, initialVelocity: initialVelocity)
    }
    
}
