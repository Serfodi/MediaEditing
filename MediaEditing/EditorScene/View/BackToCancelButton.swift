//
//  BackToCancelButton.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 21.02.2023.
//

import UIKit
import Lottie


enum ButtonState {
    case cancel
    case back
}

protocol ButtonDelegate: AnyObject {
    
    func tap()
    
}


class BackToCancelButton: UIView {

    private var animationButtonView: AnimationView!
    private var button: UIButton!
    
    var delegate: ButtonDelegate?
    
    var isState: ButtonState = .cancel
    
    override func draw(_ rect: CGRect) {
        
        button = UIButton(frame: bounds)
        button.addTarget(self, action: #selector(tap), for: .touchDown)
        
        insertSubview(button, at: 1)
        
        animationButtonView = .init(name: "backToCancel")
        animationButtonView.frame = bounds
        animationButtonView.contentMode = .scaleAspectFit
        animationButtonView.loopMode = .playOnce
        animationButtonView.animationSpeed = 1.0
        animationButtonView.currentProgress = 0.5
        
        insertSubview(animationButtonView, at: 0)
    }
    
    open func animationButton(state: ButtonState) {
        switch state {
        case .cancel:
            animationButtonView.play(toProgress: 1)
            isState = .back
        case .back:
            animationButtonView.play(toProgress: 0.5)
            isState = .cancel
        }
    }
    
    @objc func tap() {
        delegate?.tap()
    }
}
