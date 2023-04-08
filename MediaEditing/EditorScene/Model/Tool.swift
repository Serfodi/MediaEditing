//
//  Tool.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 23.02.2023.
//

import UIKit
import PencilKit

class Tool {
    
    enum ToolName: String {
        case pen = "pen"
        case pencil = "pencil"
        case brush = "brush"
        case lasso = "lasso"
        case eraser = "eraser"
    }
    
    let toolName: ToolName
    
    var widht:Float!
    var color:UIColor!
    
    var eraser: PKEraserTool.EraserType = .bitmap
    
    init(toolName: ToolName, color: UIColor! = nil, widht: Float! = nil) {
        self.toolName = toolName
        self.color = color
        self.widht = widht
    }
    
    open func getTool() -> PKTool {
        switch toolName {
        case .pen:
            return PKInkingTool(.pen, color: color, width: CGFloat(widht) * UIScreen.main.scale)
        case .pencil:
            return PKInkingTool(.pencil, color: color, width: CGFloat(widht) * UIScreen.main.scale)
        case .brush:
            return PKInkingTool(.marker, color: color, width: CGFloat(widht) * UIScreen.main.scale)
        case .lasso:
            return PKLassoTool()
        case .eraser:
            return PKEraserTool(.bitmap)
        }
    }
}


