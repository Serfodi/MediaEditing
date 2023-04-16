//
//  ImageScrollView.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 13.01.2023.
//

import UIKit


class ImageScrollView: UIScrollView, UIScrollViewDelegate {
    
    var imageSize: CGSize!
//    var imageZoomView: UIImageView!
    
    var convas = CanvasView()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.centerImage(view: convas)
    }
    
    
    
    func set(image: UIImage) {
        self.delegate = self
        // reuse
//        imageZoomView?.removeFromSuperview()
//        imageZoomView = nil
        
//        imageZoomView = UIImageView(image: image)
//        self.addSubview(imageZoomView)
        
        
        imageSize = image.size
        
        convas.frame = CGRect(origin: .zero, size: imageSize)
        addSubview(convas)
        
//        convas.set(image: image)
        
        convas.image = image
        
        configurateFor(imageSize: image.size)
    }
    
    
    func configurateFor(imageSize: CGSize) {
        self.contentSize = imageSize
        setCurrentMaxandMinZoomScale()
        self.zoomScale = self.minimumZoomScale
    }
    
    
    func setCurrentMaxandMinZoomScale() {
        let boundsSize = self.bounds.size
        let imageSize = convas.bounds.size
        
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
    
    
    func centerImage(view: UIView!) {
        guard view != nil else { return }
        
        let boundsSize = self.bounds.size
        var frameToCenter = view.frame
        
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }
        view.frame = frameToCenter
    }
    
    
    // MARK: - undo
    
    open func undo() {
        
    }
    
    
    // MARK: - undo
    
    open func clearAll() {
        
    }
    
    
    
    // MARK: - UIScrollViewDelegate
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.convas
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.centerImage(view: convas)
    }
}




// MARK: - UIGestureRecognizerDelegate


extension ImageScrollView: UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer.numberOfTouches == 2
    }
    
}
