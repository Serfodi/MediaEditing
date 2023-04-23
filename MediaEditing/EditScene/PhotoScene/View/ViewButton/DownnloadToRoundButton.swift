//
//  DownnloadToRoundButton.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 25.02.2023.
//

import UIKit

protocol ButtonTwo: AnyObject {
    
    func downnload()
    func newTip(_ newTip: Pen.TipType)
    func newEraser(_ type: Eraser.TypeEraser)
}


@IBDesignable
class DownnloadToRoundView: UIView {

    enum IsButton {
        case downnload
        case round
    }
    
    var isButton: IsButton = .downnload
    
    var delegate: ButtonTwo!
    
    private lazy var downladButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 33, height: 33)))
        if let image = UIImage(named: "download") {
            button.setBackgroundImage(image, for: .normal)
        }
        return button
    }()
    
    private lazy var roundButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont(name: "SF-Pro-Text-Semibold", size: 15)
        return button
    }()
    
    /// Устонавливает наконечник карандаша
    open var typeRoundButton: Pen.TipType = .roundTip {
        didSet {
            setTip(typeRoundButton)
        }
    }
    
    open var typeEraserButton: Eraser.TypeEraser = .eraser {
        didSet {
            setEraser(typeEraserButton)
        }
    }
    
    /// 0 – title, 1 – image name
    let titleName: [Eraser.TypeEraser: (String, String)] = [
        .eraser : ("Eraser", "RoundTip"),
        .objectEraser : ("Object", "xmarkTip"),
        .blurEraser : ("Blure", "BlurTip")
    ]
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let space = (bounds.height - 22) / 2.0
        roundButton.imageEdgeInsets = UIEdgeInsets(top: space, left: bounds.width - 22, bottom: space, right: -(bounds.width - 22))
        roundButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -22, bottom: 0, right: 22)
    }
    
    // MARK: - Action
    
    @objc func downladButtonTapped() {
        delegate.downnload()
    }
    
    func newToolTip(_ tip: Pen.TipType) {
        typeRoundButton = tip
        delegate.newTip(tip)
    }
    
    func newEraer(_ type: Eraser.TypeEraser) {
        typeEraserButton = type
        delegate.newEraser(type)
    }
    
    // MARK: - Set func
    
    private func setTip(_ type: Pen.TipType) {
        roundButton.setTitle(type.rawValue, for: .normal)
        if let image = UIImage(named: type.rawValue + "Tip")?.resizeImage(size: CGSize(width: 22, height: 22)) {
            roundButton.setImage(image, for: .normal)
        }
        setButtonMenu()
    }
    
    private func setEraser(_ type: Eraser.TypeEraser) {
        roundButton.setTitle(titleName[type]?.0, for: .normal)
        if let image = UIImage(named: titleName[type]!.1)?.resizeImage(size: CGSize(width: 22, height: 22)) {
            roundButton.setImage(image, for: .normal)
        }
        
        setEraserMenu()
    }
    
    
    // MARK: Setup View
    
    private func setupView() {
        overrideUserInterfaceStyle = .dark
        addSubview(roundButton)
        addSubview(downladButton)
        roundButton.alpha = 0
        roundButton.transform = CGAffineTransformMakeScale(0.2, 0.2)
        roundButton.showsMenuAsPrimaryAction = true
        downladButton.addTarget(self, action: #selector(downladButtonTapped), for: .touchUpInside)
        setRoundButtonConstraints(for: roundButton)
        setDownladButtonConstraints(for: downladButton)
        roundButton.isHidden = true
    }
    
    private func setRoundButtonConstraints(for view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
    }
    
    private func setDownladButtonConstraints(for view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
    
    
    private func setButtonMenu() {
        roundButton.menu = nil
        var actions:[UIAction] = []
        for i in Pen.TipType.allCases.reversed()  {
            let action = UIAction(title: NSLocalizedString(i.rawValue , comment: ""), image: UIImage(named: i.rawValue  + "Tip")) { action in
                self.newToolTip(i)
            }
            actions.append(action)
        }
        roundButton.menu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: actions)
    }
    
    
    private func setEraserMenu() {
        roundButton.menu = nil
        var actions:[UIAction] = []
        for i in Eraser.TypeEraser.allCases.reversed()  {
            let action = UIAction(title: NSLocalizedString(titleName[i]!.0, comment: ""), image: UIImage(named: titleName[i]!.1 )) { action in
                self.newEraer(i)
            }
            actions.append(action)
        }
        roundButton.menu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: actions)
    }
    
    
    
    // MARK: - Animation
    
    open func animationSwicht(to state: IsButton) {
        switch state {
        case .downnload:
            animationButton(to: roundButton, from: downladButton)
        case .round:
            animationButton(to: downladButton, from: roundButton)
        }
        isButton = state
    }
    
    private func animationButton(to: UIView, from: UIView) {
        let animateButton = UIViewPropertyAnimator(duration: 0.4, curve: .linear)
        from.isHidden = false
        animateButton.addAnimations {
            to.transform = CGAffineTransformMakeScale(0.4, 0.4)
            to.alpha = 0
            from.transform = .identity
            from.alpha = 1
        }
        animateButton.addCompletion { _ in
            to.isHidden = true
        }
        animateButton.startAnimation()
    }
     
}
