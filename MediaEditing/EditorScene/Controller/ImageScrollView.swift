//
//  ImageScrollView.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 13.01.2023.
//

import UIKit


class ImageScrollView: UIScrollView, UIScrollViewDelegate {
    

    
    var settingColorRGB = SettingColorRGB(red: 1, green: 1, blue: 1, opacity: 1)
    
    var brushWidth: CGFloat = 14.0
    var opacity: CGFloat = 1.0
    
    var lastPoint = CGPoint.zero
    var swiped = false
    
    var imageSize: CGSize!
    var imageZoomView: UIImageView!
    var tempImageView: UIImageView!
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.centerImage(view: imageZoomView)
    }
    
    
    
    func set(image: UIImage) {
        self.delegate = self
        
        // reuse
        imageZoomView?.removeFromSuperview()
        imageZoomView = nil
        
        imageZoomView = UIImageView(image: image)
        imageZoomView.backgroundColor = .green
        
        imageSize = image.size
        
        self.addSubview(imageZoomView)
        
        configurateFor(imageSize: image.size)
    }
    
    func configurateFor(imageSize: CGSize) {
        self.contentSize = imageSize
        setCurrentMaxandMinZoomScale()
        self.zoomScale = self.minimumZoomScale
    }
    
    func setCurrentMaxandMinZoomScale() {
        let boundsSize = self.bounds.size
        let imageSize = imageZoomView.bounds.size
        
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
    
    
    // MARK: - undu and clear
    
    open func undo() {
        imageZoomView.subviews.last?.removeFromSuperview()
    }
    
    open func clearAll() {
        for view in imageZoomView.subviews {
            view.removeFromSuperview()
        }
    }
    
    
    
    // MARK: - UIScrollViewDelegate
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageZoomView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.centerImage(view: imageZoomView)
    }
        
    
    
    // MARK: Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            tempImageView = UIImageView(frame: imageZoomView.bounds)
            imageZoomView.addSubview(tempImageView)
            lastPoint = touch.location(in: imageZoomView)
        }
    }
    
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        
        UIGraphicsBeginImageContext(imageSize)
        
        let context = UIGraphicsGetCurrentContext()
        
        tempImageView.image?.draw(
            in: CGRect(x: 0, y: 0,
                       width: imageSize.width,
                       height: imageSize.height))
        
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        
        context?.setLineCap(.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(red: settingColorRGB.red, green: settingColorRGB.green, blue: settingColorRGB.blue, alpha: settingColorRGB.opacity)
        context?.setBlendMode(.normal)
        
        context?.strokePath()
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        
        UIGraphicsEndImageContext()
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: imageZoomView)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            lastPoint = currentPoint
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint)
    }
    
    
    
    // Merge tempImageView into mainImageView
    //        UIGraphicsBeginImageContext(imageSize)
    //
    //        imageZoomView.image?.draw(
    //            in: CGRect(x: 0, y: 0,
    //                       width: imageSize.width,
    //                       height: imageSize.height),
    //            blendMode: .normal,
    //            alpha: 1.0)
    //
    //        tempImageView.image?.draw(
    //            in: CGRect(x: 0, y: 0,
    //                       width: imageSize.width,
    //                       height: imageSize.height),
    //            blendMode: .normal,
    //            alpha: opacity)
    //
    //        imageZoomView.image = UIGraphicsGetImageFromCurrentImageContext()
    //
    //        UIGraphicsEndImageContext()
    //
    //        tempImageView.image = nil
}


extension ImageScrollView: UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer.numberOfTouches == 2
    }
    
}
