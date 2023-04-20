//
//  DownnloadToRoundButton.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 25.02.2023.
//

import UIKit

protocol ButtonTwo: AnyObject {
    
    func downnload()
    func round()
}

@IBDesignable
class DownnloadToRoundView: UIView {

    enum StateButton {
        case downnload
        case round
    }
    
    var delegate: ButtonTwo!
    
    open var isState: StateButton = .downnload
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Round"
        label.font = UIFont(name: "SF-Pro-Text-Semibold", size: 15)
        label.minimumScaleFactor = 0.5
        label.textColor = .white
        return label
    }()
    
    lazy var imageDownloadView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "download")
        return imageView
    }()
    
    private var shapeImageView: UIImageView!
    
    private var stackView: UIStackView = UIStackView(arrangedSubviews: [])
    
    
    open var imageName: String! {
        didSet {
            if let image = UIImage(named: imageName) {
                shapeImageView.image = image
            }
        }
    }
    
    
    
    var button = UIButton()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
        button.frame = bounds
    }
    
    // MARK: Draw
    
    override func draw(_ rect: CGRect) {
        setupView()
    }
    
    @objc func tapButton() {
        switch isState {
        case .downnload:
            delegate.downnload()
        case .round:
            delegate.round()
        }
    }
    
    
    // MARK: SetupView
    
    
    func setupView() {
        setupImageView()
        setupStackView()
        stackView.alpha = 0
        stackView.isHidden = true
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        addSubview(button)
        overrideUserInterfaceStyle = .dark
    }
    
    private func setupImageView() {
        imageDownloadView.frame = bounds
        addSubview(imageDownloadView)
        imageDownloadView.translatesAutoresizingMaskIntoConstraints = false
        imageDownloadView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageDownloadView.heightAnchor.constraint(equalToConstant: 33).isActive = true
        imageDownloadView.widthAnchor.constraint(equalToConstant: 33).isActive = true
    }
    
    private func setupStackView() {
        shapeImageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 25, height: 25)) )
        
        stackView = UIStackView(arrangedSubviews: [])
        addSubview(stackView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(shapeImageView)
        
        stackView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.frame = bounds
        
        shapeImageView.translatesAutoresizingMaskIntoConstraints = false
        shapeImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        shapeImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    
    // MARK: Animation
    
    open func animationSwicht(to state: StateButton) {
        switch state {
        case .downnload:
            animtaionDownnload()
        case .round:
            animationRound()
        }
        isState = state
    }

    
    
    // Из Downnload -> Round
    private func animationRound() {
        stackView.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            self.imageDownloadView.transform = CGAffineTransformMakeScale(0.2, 0.2)
            self.stackView.alpha = 1
        }) { (true) in
            self.imageDownloadView.isHidden = true
        }
        
        
    }
    
    // Из Round -> Downnload
    private func animtaionDownnload() {
        self.imageDownloadView.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            self.imageDownloadView.transform = .identity
            self.stackView.alpha = 0
        }) { (true) in
            self.stackView.isHidden = true
        }
    }
    
}
