//
//  ToolsDrawButton.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 09.02.2023.
//

import UIKit


class ToolsDrawCell: UICollectionViewCell {

    var tool: Tool! {
        didSet {
            if let image = UIImage(named: tool.toolName.rawValue) {
                toolImageView.image = image
            }
            tipImageView.image = UIImage(named: tool.toolName.rawValue + "Tip")
            if tool.widht != nil {
                setupViewWidth()
                setWidth(CGFloat(tool.widht))
            }
            if let color = tool.color {
                setColor(color)
            }
        }
    }
    
    var viewWidth: UIView!
    var tipView: UIView!
    
    var toolImageView: UIImageView!
    var tipImageView: UIImageView!
    let gradientLayer = CAGradientLayer()
    
    
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
   
    
    
    
    /// Устонавливает цвет картинки грифиля
    open func setColor(_ color: UIColor) {
        if tipImageView.image != nil {
            tipView.backgroundColor = color
        }
        if !viewWidth.isHidden {
            viewWidth.backgroundColor = color
        }
    }
    
    /// Устонавливает ширину корондаша
    open func setWidth(_ height: CGFloat) {
        tool.widht = Float(height)
        viewWidth.frame = CGRect(origin: viewWidth.frame.origin, size: CGSize(width: viewWidth.frame.width, height: height))
    }
    
    
    private func setToolImage(image: UIImage) {
        toolImageView.image = image
    }
    
    private func setTipImage(image: UIImage) {
        tipImageView.image = image
    }
    
    
    // MARK: - Setup
    
    private func setup() {
        toolImageView = UIImageView(frame: bounds)
        toolImageView.contentMode = .scaleAspectFit
        addSubview(toolImageView)
        
        tipView = UIView(frame: bounds)
        tipImageView = UIImageView(frame: bounds)
        tipView.mask = tipImageView
        addSubview(tipView)
        
    }
    
    private func setupViewWidth() {
        viewWidth = UIView(frame: CGRect(x: 1.5, y: tool.widhtPozition[tool.toolName]!, width: 17, height: 88))
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
    
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        toolImageView.image = nil
        tipImageView.image = nil
    }
    
    
    

    
    
}
