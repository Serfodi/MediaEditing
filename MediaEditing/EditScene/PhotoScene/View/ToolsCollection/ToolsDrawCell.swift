//
//  ToolsDrawButton.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 09.02.2023.
//

import UIKit


//@objc protocol ToolsDrawCellTouchDelegate: AnyObject {
//    
//    // touch
//    @objc optional func startTouch()
//    @objc optional func beginTouch(_ deltaWidth: CGFloat)
//    @objc optional func endTouch()
//    
//}



/// Предстовление инструмента
class ToolsDrawCell: UICollectionViewCell {

    var tool: Tool! {
        didSet {
            if let image = UIImage(named: tool.imageName) {
                toolImageView.image = image
            }
            if let pen = tool as? Pen {
                tipImageViewSetup()
                widthViewSetup()
                maxWidth = pen.validWidthRange.upperBound
                setWidth(pen.width)
                setColor(pen.color)
            }
        }
    }
    
    private let widthPozition: [String : CGFloat] = [
        Pen.PenType.pen.rawValue : 40,
        Pen.PenType.brush.rawValue : 36,
        Pen.PenType.pencil.rawValue : 40,
        Pen.PenType.neon.rawValue : 36
    ]
    
    // Базовая картинка
    private var toolImageView: UIImageView!
    
    // Для изменения ширины
    private var viewWidth: UIView!
    private var maxWidth: CGFloat!
    private var maxWidhtView: CGFloat = 24
    // Для изменения цвета
    private var tipView: UIView!
    
    
    open var isSelectedTool: Bool = false {
        didSet {
            selectCellAnimation(is: isSelectedTool, self)
        }
    }
    
    weak var touchDelegate: ToolsDrawCellTouchDelegate?
    
//    private var startWidth: CGFloat!
//    private var startTouchLocal: CGPoint!
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
   
    
    
    // MARK: - set func
    
    /// Устонавливает цвет картинки грифиля
    open func setColor(_ color: UIColor) {
        guard tipView != nil && viewWidth != nil else { return }
        tipView.backgroundColor = color
        viewWidth.backgroundColor = color
    }
    
    /// Устонавливает ширину корондаша просмотра
    open func setWidth(_ height: CGFloat) {
        guard viewWidth != nil else { return }
        var newWidht = height / maxWidth * maxWidhtView
        newWidht = newWidht < 4 ? 4 : newWidht
        viewWidth.frame = CGRect(origin: viewWidth.frame.origin, size: CGSize(width: viewWidth.frame.width, height: newWidht))
    }
    
    
    
    // MARK: - Touches
    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            startTouchLocal = touch.location(in: self)
            touchDelegate?.startTouch?()
        }
    }
    
    
    // Изменения ширины путем перемещения пальца вверх или вниз по экрану
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard isSelectedTool else { return }
        if let touch = touches.first {
            let currentLocal = touch.location(in: self)
            let distance = (startTouchLocal.y - currentLocal.y)
            startTouchLocal = currentLocal
            touchDelegate?.beginTouch?(distance.rounded())
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touchDelegate?.endTouch?()
    }
    */
    
    
    
    // MARK: - Setup
    
    private func setup() {
        toolImageView = UIImageView(frame: bounds)
        toolImageView.contentMode = .scaleAspectFit
        addSubview(toolImageView)
    }
    
    private func tipImageViewSetup() {
        guard let image = UIImage(named: tool.imageName + "Tip") else { return }
        let tipImageView = UIImageView(frame: bounds)
        tipImageView.image = image
        tipView = UIView(frame: bounds)
        tipView.mask = tipImageView
        addSubview(tipView)
    }
    
    
    /// Добовляет градент "Тень" на "viewWidth"
    private func widthViewSetup() {
        viewWidth = UIView(frame: CGRect(x: 1.5, y: widthPozition[tool.imageName]!, width: 17, height: 88))
        viewWidth.layer.cornerRadius = 2
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = viewWidth.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.locations = [0, 0.3, 0.7, 1]
        gradientLayer.colors = [
            CGColor(gray: 0, alpha: 0.2),
            CGColor(gray: 0, alpha: 0),
            CGColor(gray: 0, alpha: 0),
            CGColor(gray: 0, alpha: 0.2)
        ]
        viewWidth.layer.addSublayer(gradientLayer)
        toolImageView.addSubview(viewWidth)
    }
    
    
    
    /// Анимация выделения яцейки
    /// Поднимает или опускает ее на 16
    private func selectCellAnimation(is isSelect: Bool, _ cell: UICollectionViewCell) {
        let time = UISpringTimingParameters(damping: 0.5, response: 0.3)
        let animtaion = UIViewPropertyAnimator(duration:  0.05, timingParameters: time)
        animtaion.addAnimations {
            if isSelect {
                cell.frame.origin.y -= 16
            } else {
                cell.frame.origin.y += 16
            }
        }
        animtaion.isInterruptible = true
        animtaion.startAnimation()
    }
    
}
