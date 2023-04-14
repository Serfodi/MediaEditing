//
//  DuckViewController.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 21.02.2023.
//

import UIKit
import Lottie
import Photos


class DuckViewController: UIViewController {

    
    var duckView: AnimationView!
    var label: UILabel!
//    var accessButton: UIButton!
    
    var stackView: UIStackView = UIStackView(arrangedSubviews: [])
    
    var shineButton: ShineButton!
    
    // MARK: - UIViewController / Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        setup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shineButton.animationLayer()
        duckView.play()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        stackView.layoutIfNeeded()
    }
    
    
    
    
    
    
    // MARK: - Action
    
    @objc func allowAccess(_ sender: UIButton) {
        
        let isWriteRead = DataModelController.accsesPhoto()
        
        if isWriteRead {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let gallary = storyboard.instantiateViewController(withIdentifier: "GalleryColletionVC") as? GalleryCollectionViewController else { return }
            
            gallary.modalPresentationStyle = .fullScreen
            gallary.modalTransitionStyle = .coverVertical
            
            present(gallary, animated: true)
        } else {
            // go setting
            alert()
        }
    }
    
    
    // MARK: - Alert
    
    func alert() {
        let alert = UIAlertController(title: "Allow access to your photos",
                                      message: "This lets you share from your camera roll and enables other features for photos and videos. Go to your settings and tap \"Photos\".",
                                      preferredStyle: .alert)
        
        let notNowAction = UIAlertAction(title: "Not Now",
                                         style: .cancel,
                                         handler: nil)
        alert.addAction(notNowAction)
        
        let openSettingsAction = UIAlertAction(title: "Open Settings",
                                               style: .default) { [unowned self] (_) in
            // Open app privacy settings
            gotoAppPrivacySettings()
            
        }
        alert.addAction(openSettingsAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func gotoAppPrivacySettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(url) else {
                assertionFailure("Not able to open App privacy settings")
                return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    // MARK: - setup
    
    func setup() {
        setupDuckView()
        setupLabel()
        setupButton()
        stackView.addArrangedSubview(duckView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(shineButton)
        self.view.addSubview(stackView)
        setupStack()
        stackViewConstraint()
        setupDuckViewConstraint()
        accessButtonConstraint()
    }
    
    func setupStack() {
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
    }
    
    func stackViewConstraint() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
    }
    
    func setupDuckView() {
        duckView = .init(name: "duck")
        duckView.frame = CGRect(origin: .zero, size: CGSize(width: 144, height: 144))
        duckView.loopMode = .autoReverse
        duckView.contentMode = .scaleAspectFill
    }
    
    func setupDuckViewConstraint() {
        duckView.translatesAutoresizingMaskIntoConstraints = false
        duckView.heightAnchor.constraint(equalToConstant: 144).isActive = true
        duckView.widthAnchor.constraint(equalToConstant: 144).isActive = true
    }
    
    func setupLabel() {
        label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: 24)))
        label.text = "Access Your Photos and Videos"
        label.font = UIFont(name: "SF-Pro-Text-Semibold", size: 20)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
    }

    func setupButton() {
//        shim = Shine(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: 50)))
//        shim.backgroundColor = UIColor(red: 0, green: 121 / 255, blue: 1, alpha: 1)
//        shim.text = "Allow Access"
//        shim.font = UIFont(name: "SF-Pro-Text-Semibold", size: 20)
//        shim.textColor = .white
//        shim.textAlignment = .center
//        shim.layer.cornerRadius = 10
        
//        accessButton = UIButton(type: .custom)
//        accessButton.frame = CGRect(origin: .zero, size: CGSize(width: 0, height: 50))
//        accessButton.setTitle("Allow Access", for: .normal)
//        accessButton.titleLabel?.font = UIFont(name: "SF-Pro-Text-Semibold", size: 20)
//        accessButton.setTitleColor( .white, for: .normal)
//        accessButton.backgroundColor = UIColor(red: 0, green: 121 / 255, blue: 1, alpha: 1)
//        accessButton.layer.cornerRadius = 10
//        accessButton.addTarget(self, action: #selector(allowAccess), for: .touchUpInside)
        
        shineButton = ShineButton(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: 50)) )
        shineButton.setTitle("Allow Access", for: .normal)
        shineButton.titleLabel?.font = UIFont(name: "SF-Pro-Text-Semibold", size: 20)
        shineButton.setTitleColor( .white, for: .normal)
        shineButton.backgroundColor = UIColor(red: 0, green: 121 / 255, blue: 1, alpha: 1)
        shineButton.layer.cornerRadius = 10
        shineButton.addTarget(self, action: #selector(allowAccess), for: .touchUpInside)
    }
    
    func accessButtonConstraint() {
        shineButton.translatesAutoresizingMaskIntoConstraints = false
        shineButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        shineButton.leftAnchor.constraint(equalTo: self.stackView.leftAnchor, constant: 0).isActive = true
        shineButton.rightAnchor.constraint(equalTo: self.stackView.rightAnchor, constant: 0).isActive = true
    }
    
}





final class ShineButton: UIButton {
        
    var gradientBaseLayer = CAGradientLayer()
    var gradientBorderBLayer = CAGradientLayer()
    
    override func draw(_ rect: CGRect) {
        
        clipsToBounds = true
        backgroundColor = .clear
        layer.cornerRadius = 10
        
        setupGradient(gradientBaseLayer)
        setupGradient(gradientBorderBLayer)
        
        gradientBorderBLayer.frame = bounds
        gradientBaseLayer.frame = bounds
        self.layer.addSublayer(gradientBaseLayer)
        
        let pacth = UIBezierPath(roundedRect: bounds, cornerRadius: 10)
        let rectClip = CGRect(origin: CGPoint(x: 1.33, y: 1.33), size: CGSize(width: bounds.width - 1.33 * 2, height: bounds.height - 1.33 * 2))
        let pachtClip = UIBezierPath(roundedRect: rectClip, cornerRadius: 9)
        pacth.append(pachtClip)
        
        let mask = CAShapeLayer()
        mask.fillRule = .evenOdd
        gradientBorderBLayer.mask = mask
        
        (gradientBorderBLayer.mask as? CAShapeLayer)?.frame = bounds
        (gradientBorderBLayer.mask as? CAShapeLayer)?.path = pacth.cgPath
        
        self.layer.addSublayer(gradientBorderBLayer)
    }
    
    
    private func setupGradient(_ GradientBaseLayer: CAGradientLayer) {
        GradientBaseLayer.colors = [
          UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor,
          UIColor(red: 1, green: 1, blue: 1, alpha: 0.85).cgColor,
          UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor,
          UIColor(red: 1, green: 1, blue: 1, alpha: 0.85).cgColor,
          UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor
        ]
        GradientBaseLayer.locations = [0, 0.4, 0.52, 0.65, 1]
        GradientBaseLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
        GradientBaseLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
        GradientBaseLayer.compositingFilter = "softLightBlendMode"
    }
    
    
    func animationLayer() {
        
        let theAnimation = CABasicAnimation(keyPath: "position")
        theAnimation.fromValue = [-self.frame.width * 2, self.frame.height / 2]
        theAnimation.toValue = [self.frame.width * 3, self.frame.height / 2]
        theAnimation.duration = 1.0 * 4.0
        theAnimation.autoreverses = true
        theAnimation.repeatCount = .infinity
        
        self.gradientBaseLayer.add(theAnimation, forKey: "animatePosition")
        self.gradientBorderBLayer.add(theAnimation, forKey: "animatePosition")
    }
    
    
}
