//
//  Model.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 20.04.2023.
//

import UIKit
import PencilKit

struct DataModel {
    
    static let tools = [
        Tool(toolName: .pen, color: UIColor(red: 1, green: 70 / 255, blue: 70 / 255, alpha: 1), widht: 12, toolTip: [.RoundTip, .ArrowTip], currentTip: .RoundTip),
        Tool(toolName: .brush, color: UIColor(red: 155 / 255, green: 1, blue: 155 / 255, alpha: 1), widht: 14, toolTip: [.RoundTip, .ArrowTip], currentTip: .RoundTip),
        Tool(toolName: .neon, color: UIColor(red: 55 / 255, green: 100 / 255, blue: 1, alpha: 1), widht: 8, toolTip: [.RoundTip, .ArrowTip], currentTip: .RoundTip),
        Tool(toolName: .pencil, color: UIColor(red: 231 / 255, green: 231 / 255, blue: 231 / 255, alpha: 1), widht: 24, toolTip: [.RoundTip, .ArrowTip], currentTip: .RoundTip),
        Tool(toolName: .lasso),
        Tool(toolName: .eraser, toolTip: [.RoundTip, .BlurTip], currentTip: .BlurTip )
    ]
 
    var tool: Tool = tools[0]
    
}


class DataModelController {
    
    var dataModel = DataModel()
    
    var currentTool: Tool {
        get { dataModel.tool }
    }
    
}
