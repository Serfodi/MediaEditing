//
//  AddButton.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 15.04.2023.
//

import UIKit


protocol AddButtonDelegate: AnyObject {
    
     func getFigure(_ figure: DrawingFigure.Figure)
}


class AddButton: UIButton {

    weak var delegate: AddButtonDelegate?
    
    private let menuPacth:[DrawingFigure.Figure] = [.Rectangle, .Ellipse, .Bubble, .Star, .Arrow]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        return true
    }
    
    
    private func setup() {
        
        if #available(iOS 14.0, *) {
            showsMenuAsPrimaryAction = true
        }
        
        overrideUserInterfaceStyle = .dark
        
        if #available(iOS 14.0, *) {
            var actions:[UIAction] = []
            
            for i in self.menuPacth.reversed() {
                let action = UIAction(title: NSLocalizedString(i.rawValue, comment: ""),
                         image: UIImage(named: "shape" + i.rawValue)) { action in
                    self.delegate?.getFigure(i)
                }
                actions.append(action)
            }
            menu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: actions)
        }
    }
    
    
}
