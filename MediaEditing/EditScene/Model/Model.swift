//
//  Model.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 20.04.2023.
//

import UIKit
import PencilKit

struct DataModel {
        
    var tools: [Tool] = [
        Pen(toolType: .pen, color: #colorLiteral(red: 0.3215686275, green: 0.8392156863, blue: 0.9882352941, alpha: 1), width: 10),
        Pen(toolType: .brush, color: #colorLiteral(red: 0.9213342071, green: 0.3150518239, blue: 0.1814081669, alpha: 1), width: 10),
        Pen(toolType: .neon, color: #colorLiteral(red: 1, green: 0.968627451, blue: 0.4196078431, alpha: 1), width: 10),
        Pen(toolType: .pencil, color: #colorLiteral(red: 0.9568627451, green: 0.6431372549, blue: 0.7529411765, alpha: 1), width: 10),
        Lasso(),
        Eraser(type: .eraser, width: 10)
    ]
    
    var indexTool: Int = 0
 
}


class DataModelController {
    
    var dataModel = DataModel()
    
    var currentTool: Tool {
        set {
            dataModel.tools[dataModel.indexTool] = newValue
        }
        get {
            dataModel.tools[dataModel.indexTool]
        }
    }
    
    
    /**
     Выдает инструмент по индексу яцейки.
     Обновляет текущию
     */
    func setNewTool(index: Int) {
        dataModel.indexTool = index
    }
    
    func getCurrentColor() -> UIColor? {
        if let pen = currentTool as? Pen {
            return pen.color
        }
        return nil
    }
    
    func setColor(_ color: UIColor) {
        if let pen = currentTool as? Pen {
            currentTool = Pen(toolType: pen.toolType, color: color, width: pen.width)
        }
    }
    
    func setPenTip(_ tip: Pen.TipType) {
        if let pen = currentTool as? Pen {
            var newPen = pen
            newPen.tipType = tip
            currentTool = newPen
        }
    }
    
    func setEraser(_ type: Eraser.TypeEraser) {
        if let eraser = currentTool as? Eraser {
            currentTool = Eraser(type: type, width: eraser.width)
        }
    }
    
    func setWidth(_ width: CGFloat) {
        if let eraser = currentTool as? Eraser {
            var newEraser = eraser
            newEraser.width = width
            currentTool = newEraser
        } else if let pen = currentTool as? Pen {
            var newPen = pen
            newPen.width = width
            currentTool = newPen
        }
    }
    
}
