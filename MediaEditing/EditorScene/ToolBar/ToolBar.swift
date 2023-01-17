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
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurEffectView, at: 0)
    }
    
}
