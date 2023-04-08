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
            if tool.widht == nil {
                viewWidth.isHidden = true
            } else {
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
    
    
    
    // MARK: - Setup
    
    private func setup() {
        toolImageView = UIImageView(frame: frame)
        addSubview(toolImageView)
        
        tipView = UIView(frame: frame)
        tipImageView = UIImageView(frame: frame)
        tipView.mask = tipImageView
        addSubview(tipView)
        
        viewWidth = UIView(frame: CGRect(x: 1.5, y: 40, width: 17, height: 4))
        viewWidth.layer.cornerRadius = 2
        addSubview(viewWidth)
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        toolImageView.image = nil
        tipImageView.image = nil
    }
    
    
}
