//
//  Tool.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 23.02.2023.
//

import Foundation

enum ToolImageName: String {
    case pen = "pen"
    case pencil = "pencil"
    case brush = "brush"
    case lasso = "lasso"
    case eraser = "eraser"
}


class Tool {
    
    let toolImageName:String
    
    var widht:CGFloat!
    var color:SettingColorRGB!
    
    init(toolImageName: String, color: SettingColorRGB! = nil, widht: CGFloat! = nil) {
        self.toolImageName = toolImageName
        self.color = color
        self.widht = widht
    }
    
}
