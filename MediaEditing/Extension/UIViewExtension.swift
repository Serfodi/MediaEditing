//
//  UIViewExtension.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 16.04.2023.
//

import UIKit

extension UIView {
    
    var snapshot: UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let capturedImage = renderer.image { context in
            layer.render(in: context.cgContext)
        }
        return capturedImage
    }
    
}
