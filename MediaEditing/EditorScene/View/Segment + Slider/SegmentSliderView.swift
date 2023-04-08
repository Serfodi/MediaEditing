//
//  Segment + Slider.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 03.02.2023.
//

import UIKit




@IBDesignable
class SegmentSliderView: UIView {
    
    enum Controller {
        case segment
        case slider
    }
    
    var baseLayer = CAShapeLayer()
    
    var slider:WidthSlider!
    var segment:RoundSegmentedControl!
    
    open var correctControler: Controller = .segment
    
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if  correctControler == .segment {
            slider.frame = bounds
            slider.layoutSubviews()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        slider.frame = rect
        segment.frame = rect
        baseLayer.path = segment.baseLayerPath(rect).cgPath
        baseLayer.fillColor = UIColor(white: 1, alpha: 0.1).cgColor
        
        slider.baseLayerHide()
        segment.baseLayerHide()
        slider.isHidden = true
                
        addSubview(segment)
        addSubview(slider)
        layer.insertSublayer(baseLayer, at: 1)
    }
    
    
    
    // MARK: - Animation
    
    open func animationControler(to controller: Controller) {
        correctControler = controller
        switch controller {
        case .segment:
            animationToSegment()
        case .slider:
            animationToSlider()
        }
    }
    
    
    // Анимация из слайдера в сегмент
    private func animationToSegment() {
        segment.isHidden = false
        slider.isHidden = true
        
        // Устоновка слайдера в позицию ползунка
        segment.slideView.frame = slider.thumbRect()
        
        // Анимация базового слоя
        baseLayer.add(animationForm(at: slider.baseLayer, to: segment.baseLayer), forKey: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            self.segment.slideView.frame = self.segment.slideViewRect
            self.segment.slideView.backgroundColor = self.segment.slidLayerColor
            self.segment.slideView.layer.cornerRadius = self.segment.slideViewRect.height / 2
            self.segment.stackView.transform = .identity
            self.segment.stackView.alpha = 1
        }) { (true) in
            
        }
    }
    
    // Анимация из сегмента в слайдер
    private func animationToSlider() {
        
        // Анимация базового слоя
        baseLayer.add(animationForm(at: segment.baseLayer, to: slider.baseLayer), forKey: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            self.segment.stackView.transform = CGAffineTransform(scaleX: 1, y: 0.5)
            self.segment.stackView.alpha = 0
            self.segment.slideView.backgroundColor = .white
            self.segment.slideView.frame = self.slider.thumbRect()
            self.segment.slideView.layer.cornerRadius = self.segment.slideView.frame.height / 2
        }) { (true) in
            self.segment.isHidden = true
            self.slider.isHidden = false
        }
    }
    
    private func animationForm(at one: CAShapeLayer, to two: CAShapeLayer) -> CABasicAnimation {
        let patchAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.path))
        patchAnimation.fromValue = one.path
        baseLayer.path = two.path
        patchAnimation.toValue = two.path
        patchAnimation.duration = 0.5
        return patchAnimation
    }
    
    
    
    // MARK: - setup
    
    private func setup() {
        slider = WidthSlider()
        segment = RoundSegmentedControl()
        clear()
    }
    
    private func clear() {
        backgroundColor = .clear
    }
}

