//
//  Tool.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 23.02.2023.
//

import UIKit
import PencilKit


protocol Tool {

    var imageName: String! { get }
}

public struct Pen: Tool {
    
    var imageName: String! { get { toolType.rawValue } }
    
    var width: CGFloat {
        didSet {
            setType(toolType)
        }
    }
    
    var color: UIColor {
        didSet {
            setType(toolType)
        }
    }
    
    var tool: PKInkingTool!
    
    public enum PenType: String {
        case pen = "pen"
        case pencil = "pencil"
        case brush = "brush"
        case neon = "neon"
    }
    
    public enum TipType: String, CaseIterable {
        case arrowTip = "Arrow"
        case roundTip = "Round"
    }
    
    // Обновляет инстумент tool
    public var toolType: PenType {
        didSet {
            setType(toolType)
        }
    }
    
    public var validWidthRange: ClosedRange<CGFloat>!
    
    public var tipType: TipType = .roundTip
    
    init(toolType: PenType, color: UIColor, width: CGFloat) {
        self.toolType = toolType
        self.color = color
        self.width = width
        setType(toolType)
        validWidthRange = 4...tool.inkType.validWidthRange.upperBound
    }
    
    
    // MARK: - setType
    
    private mutating func setType(_ type: PenType) {
        switch type {
        case .pen:
            tool = PKInkingTool( .pen , color: color, width: width)
        case .pencil:
            tool = PKInkingTool( .pencil , color: color, width: width)
        case .brush:
            tool = PKInkingTool( .marker , color: color, width: width)
        case .neon:
            tool = PKInkingTool( .marker , color: color, width: width)
        }
    }
    
    
    // Neon
    
    private func addNeonEffect(colors: (dark: UIColor, light: UIColor), height:CGFloat) -> UIColor {
        let size = height/3
        let image = UIGraphicsImageRenderer(size: CGSize(width: size * 2, height: size * 2)).image { context in
            colors.dark.setFill()
            context.fill(CGRect(x: 0, y: 0, width: size * 2, height: size * 2))
            colors.light.setFill()
            context.fill(CGRect(x: size, y: 0, width: size, height: size))
            context.fill(CGRect(x: 0, y: size, width: size, height: size))
        }
        return UIColor(patternImage: image)
    }
    
    
    
}



// MARK: - Eraser

public struct Eraser: Tool {
    
    var imageName: String! { get { typeEraser.rawValue } }
    
    var width: CGFloat! { didSet { setWidth(width) } }
    
    var tool: PKTool!
    
    public enum TypeEraser: String, CaseIterable {
        // Совподает с названием картинок tool
        case eraser = "eraser"
        case objectEraser = "objectEraser"
        case blurEraser = "blurEraser"
    }
    
    // Обновляет инстумент tool
    var typeEraser: TypeEraser {
        didSet {
            setType(typeEraser)
        }
    }
    
    public var validWidthRange: ClosedRange<CGFloat> = 5...25
    
    
    
    // MARK:  init
    
    public init(type: TypeEraser, width: CGFloat) {
        self.typeEraser = type
        self.width = width
        setType(typeEraser)
    }
    
    
    // MARK:  setType
    
    private mutating func setType(_ type: TypeEraser) {
        switch type {
        case .eraser:
            tool = PKEraserTool(.bitmap)
        case .objectEraser:
            tool = PKEraserTool(.vector)
        case .blurEraser:
            // Пока непонятно
            tool = PKInkingTool(.pen, color: getBlureColor(), width: width)
        }
    }
    
    
    // MARK: - setWidth
    
    private func setWidth(_ width: CGFloat) {
        guard typeEraser != .objectEraser else { return }
        // Устновить ширину
        
    }
    
    
    // MARK: - support func
    
    private func getBlureColor() -> UIColor {
        return UIColor(white: 1, alpha: 1)
    }
}



// MARK: - Lasso

public struct Lasso: Tool {
    
    var imageName: String! { get { "lasso" } }
 
    var tool: PKLassoTool = PKLassoTool()
}
