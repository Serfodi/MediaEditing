//
//  DrawingFigure.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 15.04.2023.
//

import UIKit

struct DrawingFigure {
    
    enum Figure: String {
        case Rectangle = "Rectangle"
        case Ellipse = "Ellipse"
        case Bubble = "Bubble"
        case Star = "Star"
        case Arrow = "Arrow"
    }
    
}

struct ToolTip {
    
    enum Tip: String {
        case ArrowTip = "Arrow"
        case BlurTip = "Blur"
        case RoundTip = "Round"
    }
    
}
