//
//  ToolsDrawButton.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 09.02.2023.
//

import UIKit


class ToolsDrawCell: UICollectionViewCell {

    var viewWidth: UIView!
    var toolImageView: UIImageView!
    var tipImageView: UIImageView!
    
    var hightConstraints: NSLayoutConstraint!
    
    var toolImage: UIImage! {
        didSet {
            toolImageView.image = toolImage
        }
    }
    
    var tipImage: UIImage! {
        didSet {
            tipImageView.image = tipImage
            tipImageView.image?.withRenderingMode(.alwaysTemplate)
        }
    }
    
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
        guard tipImageView != nil else { return }
        tipImageView.image?.withRenderingMode(.alwaysTemplate)
        tipImageView.tintColor = color
        viewWidth.backgroundColor = color
    }
    
    /// Устонавливает ширину корондаша
    open func setWidth(_ height: CGFloat) {
        viewWidth.frame = CGRect(origin: viewWidth.frame.origin, size: CGSize(width: viewWidth.frame.width, height: height))
    }
    
    
    
    // MARK: - Setup
    
    private func setup() {
        toolImageView = UIImageView(frame: frame)
        addSubview(toolImageView)
        tipImageView = UIImageView(frame: frame)
        addSubview(tipImageView)
        viewWidth = UIView(frame: CGRect(x: 1.5, y: 40, width: 17, height: 4))
        viewWidth.layer.cornerRadius = 2
        viewWidth.backgroundColor = .white
        addSubview(viewWidth)
    }
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        toolImageView.image = nil
        tipImageView.image = nil
    }
}
