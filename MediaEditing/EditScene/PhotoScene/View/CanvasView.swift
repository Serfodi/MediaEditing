//
//  CanvasView.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 29.03.2023.
//

import UIKit
import PencilKit

class CanvasView: PKCanvasView {
        
    open var imageView: UIImageView!
    open var image: UIImage! { didSet { set(image: image) } }
    
    
    // MARK: - Draw
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setUpCanvasView()
    }
    
    
    // MARK: - set
    
    /// Устонвалвивает картинку
    private func set(image: UIImage) {
        imageView = UIImageView(image: image)
        if let contentView = subviews.first {
            contentView.insertSubview(imageView, at: 0)
        }
        contentSize = image.size
        setupCurrentMaxandMinZoomScale()
        zoomScale = minimumZoomScale
        
        let margin = (bounds.size - contentSize) * 0.5
        let insets = [margin.width, margin.height].map { $0 > 0 ? $0 : 0 }
        contentInset = UIEdgeInsets(top: insets[1], left: insets[0], bottom: insets[1], right: insets[0])
    }
    
    /// Устонвалвивает инструмент
    open func set(_ tool: Tool) {
        self.tool = tool.getTool(Float(maximumZoomScale))
    }
    
    // MARK: - setup
    
    private func setupCurrentMaxandMinZoomScale() {
        let boundsSize = self.bounds.size
        let imageSize = image.size

        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height
        let minScale = min(xScale, yScale)

        var maxScale = 1.0
        if minScale < 0.1 {
            maxScale = 0.3
        }
        if minScale >= 0.1 && minScale < 0.5  {
            maxScale = 0.7
        }
        if minScale >= 0.5 {
            maxScale = max(1.0, minScale)
        }
        self.maximumZoomScale = maxScale
        self.minimumZoomScale = minScale
    }
    
    
    private func setUpCanvasView() {
        drawingPolicy = .anyInput
        backgroundColor = .clear
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isOpaque = false
        
        bouncesZoom = true
        
    }
}



//extension CanvasView: UIScreenshotServiceDelegate {}
