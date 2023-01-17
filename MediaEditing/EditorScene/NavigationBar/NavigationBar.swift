//
//  NavigationBar.swift
//  Custom Navigation Bar
//
//  Created by Michael Tseitlin on 08.12.2019.
//  Copyright © 2019 Michael Tseitlin. All rights reserved.
//

import UIKit

@objc protocol NavigationBarDelegate: class {
    @objc optional func undo()
    @objc optional func clearAll()
}

@IBDesignable
class NavigationBar: UIView {
    
    weak var delegate: NavigationBarDelegate?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var zoomOut: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        blur()
        zoomOut.isHidden = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        blur()
        zoomOut.isHidden = false
    }
    
    private func commonInit() {
        let bundle = Bundle(for: NavigationBar.self)
        bundle.loadNibNamed("NavigationBar", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func blur() {
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
//        let gradient = CAGradientLayer()
//        let blue = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
//        let green = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
//        gradient.colors = [blue.cgColor, green.cgColor]
//        gradient.locations = [0, 1]
//        gradient.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
//
//        blurEffectView.layer.mask = gradient
        
        insertSubview(blurEffectView, at: 0)
        
//        layer.insertSublayer(gradient, at: 0)
        
    }
    
    
    
    
    @IBAction func undo(_ sender: UIButton) {
        delegate?.undo?()
    }
    
    @IBAction func clearAll(_ sender: UIButton) {
        delegate?.clearAll?()
    }
    
}
