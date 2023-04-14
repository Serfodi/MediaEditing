//
//  RoundSegmentedControl.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 01.02.2023.
//

import UIKit

@IBDesignable
class RoundSegmentedControl: UIView {
    
    open var baseLayer = CAShapeLayer()
    open var slideView = UIView()
    
    var slideViewRect = CGRect()
    
    
    open var baseLayerColor = UIColor(white: 1, alpha: 0.1)
    open var slidLayerColor = UIColor(white: 1, alpha: 0.3)
    
    var stackView: UIStackView = UIStackView(arrangedSubviews: [])
    
    private var buttons: [UIButton] = []
    
    private var currentIndex: Int = 0
    
    var delegate: RoundSegmentedControlDelegate?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        baseLayer.path = baseLayerPath(rect).cgPath
        baseLayer.fillColor = baseLayerColor.cgColor
        layer.insertSublayer(baseLayer, at: 0)
        
        slideView.layer.cornerRadius = slideView.frame.height / 2
        slideView.backgroundColor = slidLayerColor
        
        setupFirstSelection()
    }
    

    @objc func buttonTapped(sender: UIButton!) {
        didSelectButtonAnimation(at: sender.tag)
    }
    
    
    
    func baseLayerPath(_ rect: CGRect) -> UIBezierPath {
        let radius = rect.height / 2
        
        let point1 = CGPoint(x: radius, y: 0)
        let point2 = CGPoint(x: rect.width - radius, y: 0)
        let point3 = CGPoint(x: rect.width - radius, y: rect.height)
        let point4 = CGPoint(x: radius, y: rect.height)
        
        return UIBezierPath().roundedRectPath(point1, point2, point3, point4, cornerRadius1: radius, cornerRadius2: radius)
    }
    
    
    open func baseLayerHide() {
        setNeedsDisplay()
        baseLayerColor = UIColor.clear
    }
    
    
    private func setupView() {
        buttons = [buttonCreate(title: "Draw", tag: 0), buttonCreate(title: "Text", tag: 1)]
//        currentIndex = 0
        stackViewCreate(buttons: buttons)
        pinEdges(to: stackView)
        addSubview(slideView)
    }
    
    
    /// Анимация выбора сигмента
    private func didSelectButtonAnimation(at index: Int) {
        self.delegate?.didSelectPage(index: index)
        let newButton = self.buttons[index]
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            self.slideView.frame.origin.x = newButton.frame.minX + 2
            self.layoutIfNeeded()
        }) { (true) in
            self.slideViewRect = self.slideView.frame
        }
        currentIndex = index
    }
    
    
    open func setupFirstSelection() {
        stackView.layoutSubviews()
        let newButton = buttons[currentIndex]
        slideView.frame = CGRect(origin: newButton.frame.origin, size: newButton.frame.size)
        slideView.frame.origin.y = 2
        slideView.layer.cornerRadius = slideView.frame.height / 2.0
        slideViewRect = slideView.frame
    }
    
    
    private func stackViewCreate(buttons: [UIButton]) {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        for button in buttons {
            stackView.addArrangedSubview(button)
        }
        addSubview(stackView)
    }
    
    
    private func buttonCreate(title: String, tag: Int) -> UIButton {
        let button = UIButton(type: .custom)
        button.tag = tag
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SF-Pro-Text-Semibold.otf", size: 11)
        button.addTarget(self, action: #selector(RoundSegmentedControl.buttonTapped(sender:)), for: .touchUpInside)
        return button
    }
    
    
    func pinEdges(to other: UIView) {
        other.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2).isActive = true
        other.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2).isActive = true
        other.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        other.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
    }
    
}

protocol RoundSegmentedControlDelegate {
    func didSelectPage(index: Int)
}
