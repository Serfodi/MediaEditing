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
        case neon = "neon"
        case lasso = "lasso"
        case eraser = "eraser"
    }
    
    
    public let widhtPozition: [ToolName : CGFloat] = [ .pen : 40, .brush : 36, .pencil : 40, .neon : 36 ]
    
//    public let widthArray: [ToolName : [ClosedRange<CG>] = [ .pen : 40, .brush : 36, .pencil : 40, .neon : 36 ]
    
    let toolName: ToolName
    
    open var widht:Float!
    open var color:UIColor!
    
    open var eraser: PKEraserTool.EraserType = .bitmap
    
    open var toolTip: [ToolTip.Tip]!
    
    open var currentTip: ToolTip.Tip!
    
    init(toolName: ToolName, color: UIColor! = nil, widht: Float! = nil, toolTip: [ToolTip.Tip]! = nil, currentTip: ToolTip.Tip! = nil) {
        self.toolName = toolName
        self.color = color
        self.widht = widht
        self.toolTip = toolTip
        self.currentTip = currentTip
    }
    
    open func getTool(_ scale: Float) -> PKTool {
        switch toolName {
        case .pen:
            return PKInkingTool(.pen, color: color, width: CGFloat(widht))
        case .pencil:
            return PKInkingTool(.pencil, color: color, width: CGFloat(widht))
        case .brush, .neon:
            return PKInkingTool(.marker, color: color, width: CGFloat(widht))
        case .lasso:
            return PKLassoTool()
        case .eraser:
            return PKEraserTool(.bitmap)
        }
    }
}


