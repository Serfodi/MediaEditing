//
//  ToolBar.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 14.01.2023.
//

import UIKit

@IBDesignable
class ToolBar: UIView {
    
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        blur()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        blur()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: ToolBar.self)
        bundle.loadNibNamed("ToolBar", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func blur() {
        let gradient = CAGradientLayer()
        let blue = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        let green = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        gradient.colors = [blue.cgColor, green.cgColor]
        gradient.locations = [0, 0.6]
        gradient.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        layer.insertSublayer(gradient, at: 0)
    }
    
}
