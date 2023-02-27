//
//  Tool.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 23.02.2023.
//

import Foundation


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
    var color:SettingColorRGB!
    
    init(toolName: ToolName, color: SettingColorRGB! = nil, widht: Float! = nil) {
        self.toolName = toolName
        self.color = color
        self.widht = widht
    }
}
