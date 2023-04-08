//
//  CanvasView.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 29.03.2023.
//

import UIKit
import PencilKit

class CanvasView: PKCanvasView {
        
    var imageView: UIImageView!
    
    open var image: UIImage! {
        didSet {
            set(image: image)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setUpCanvasView()
    }
    
    
    private func set(image: UIImage) {
        imageView = UIImageView(image: image)
        if let contentView = subviews.first {
            contentView.insertSubview(imageView, at: 0)
        }
        contentSize = image.size
        setCurrentMaxandMinZoomScale()
        zoomScale = minimumZoomScale
        
        contentOffset = CGPoint(x: -(bounds.width - contentSize.width) / 2,
                                y: -(bounds.height - contentSize.height) / 2)
        isScrollEnabled = true
    }
    
    
    open func set(_ tool: Tool) {
        self.tool = tool.getTool()
    }
    
    
    func setCurrentMaxandMinZoomScale() {
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
        if #available(iOS 14.0, *) {
            drawingPolicy = .anyInput
        } else {
            allowsFingerDrawing = true
        }
        backgroundColor = .clear
        isOpaque = false
        
//        delegate = self
        
        becomeFirstResponder()
    }
    
    

    
}

extension CanvasView: UIGestureRecognizerDelegate {
    
//    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        return gestureRecognizer.numberOfTouches == 2
//    }
    
}

extension CanvasView: PKCanvasViewDelegate {
    
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return imageView
//    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {

//        let offsetX: CGFloat = max((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0)
//        let offsetY: CGFloat = max((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0)
//        imageView.frame.size = CGSize(width: self.bounds.width * scrollView.zoomScale, height: self.bounds.height * scrollView.zoomScale)
//        imageView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)

    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
//        allowsFingerDrawing = false
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
//        allowsFingerDrawing = true
        becomeFirstResponder()
    }
    
}
