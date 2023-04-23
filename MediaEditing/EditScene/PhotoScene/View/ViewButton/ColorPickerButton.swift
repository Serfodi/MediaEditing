//
//  ColorPickerButton.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 29.01.2023.
//

import UIKit

@IBDesignable
class ColorPickerButton: UIButton {
    
    /// Кружок цвета в центре
    private let colorCircle = UIView()
    
    /// Кружок градиента вокруг
    private let gradientLayer = CAGradientLayer()
    
    private var gradientСirclePath = UIBezierPath()
    
    /// Цвет кружочка или его отсутсивие.
    /// Устоноавливет цвет
    open var color: UIColor? {
        willSet {
            if newValue == nil {
                // анимация исчезновения цвета
                animationColorCircleClouse()
            } else {
                colorCircle.backgroundColor = newValue
            }
        }
        didSet {
            if oldValue == nil && color != nil {
                // анимация появления цвета
                animationColorCircleOpen()
            }
        }
    }
    
    
    // MARK: - Draw
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setup()
    }
    
    
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        return true
    }
    
    
    
    // MARK: - animation
    
    open func animationShow(is show: Bool) {
        let animation = UIViewPropertyAnimator(duration: 0.4, curve: .easeIn)
        switch show {
        case true:
            isHidden = false
            animation.addAnimations {
                self.alpha = 1
                self.transform = .identity
            }
        case false:
            animation.addAnimations {
                self.alpha = 0
                self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }
            animation.addCompletion { _ in
                self.isHidden = true
            }
        }
        animation.startAnimation()
    }
    
    private func animationColorCircleOpen() {
        self.colorCircle.isHidden = false
        UIView.animate(withDuration: 0.15) {
            self.colorCircle.transform = .identity
            self.colorCircle.alpha = 1
        }
        (gradientLayer.mask as? CAShapeLayer)?.path = getPacthGradien("board").cgPath
    }
    
    private func animationColorCircleClouse() {
        (gradientLayer.mask as? CAShapeLayer)?.path = getPacthGradien("fill").cgPath
        UIView.animate(withDuration: 0.15) {
            self.colorCircle.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
            self.colorCircle.alpha = 0
        } completion: { _ in
            self.colorCircle.isHidden = true
        }
    }
    
    private func animationForm(at one: CGPath, to two: CGPath) -> CABasicAnimation {
        let patchAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.path))
        patchAnimation.fromValue = one
        (gradientLayer.mask as? CAShapeLayer)?.path = two
        patchAnimation.toValue = two
        patchAnimation.duration = 1
        return patchAnimation
    }
    
    
    
    // MARK: - setup
    
    
    private func setup() {
        backgroundColor = .clear
        gradientLayerSetup()
        colorCircleSetup()
    }
    
    private func gradientLayerSetup() {
        
        let colors:[CGColor] = [
            CGColor(red: 0.42, green: 0.36, blue: 0.91, alpha: 1),
            CGColor(red: 0.31, green: 0.78, blue: 0.88, alpha: 1),
            CGColor(red: 0.3, green: 0.91, blue: 0.53, alpha: 1),
            CGColor(red: 0.53, green: 0.9, blue: 0.27, alpha: 1),
            CGColor(red: 0.89, green: 0.89, blue: 0.27, alpha: 1),
            CGColor(red: 0.91, green: 0.58, blue: 0.27, alpha: 1),
            CGColor(red: 0.9, green: 0.27, blue: 0.27, alpha: 1),
            CGColor(red: 0.75, green: 0.29, blue: 0.76, alpha: 1)
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.type = .conic
        gradientLayer.colors = colors
        gradientLayer.frame = bounds
        
        let mask = CAShapeLayer()
        mask.fillRule = .evenOdd
        gradientLayer.mask = mask
        
        (gradientLayer.mask as? CAShapeLayer)?.frame = bounds
        (gradientLayer.mask as? CAShapeLayer)?.path = getPacthGradien("board").cgPath
        
        layer.addSublayer(gradientLayer)
    }
    
    
    private func getPacthGradien(_ state: String) -> UIBezierPath {
        switch state {
        case "fill":
            return UIBezierPath(ovalIn: bounds)
        case "board":
            let path = UIBezierPath(ovalIn: bounds)
            let clearCirclePath = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: 3, y: 3), size: CGSize(width: 27, height: 27)))
            path.append(clearCirclePath)
            return path
        default:
            return UIBezierPath(ovalIn: bounds)
        }
    }
    
    
    
    private func colorCircleSetup() {
        colorCircle.frame = CGRect(origin: CGPoint(x: 7, y: 7), size: CGSize(width: 19, height: 19))
        colorCircle.layer.cornerRadius = colorCircle.bounds.height / 2
        colorCircle.isUserInteractionEnabled = false
        addSubview(colorCircle)
    }
}
