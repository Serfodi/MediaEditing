//
//  ToolsCollectionView.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 27.02.2023.
//

import UIKit


protocol ToolsCollectionViewDelegate: AnyObject {
    
    /// Выбрана новая яцека
    func selectedNewCell(_ cell: ToolsDrawCell)
    /// Нажали еще раз на туже яцейку
    func openWidthTool(_ cell: ToolsDrawCell)
}

@objc protocol ToolsDrawCellTouchDelegate: AnyObject {
    
    // touch
    @objc optional func startTouch()
    @objc optional func beginTouch(_ deltaWidth: CGFloat)
    @objc optional func endTouch()
    
}



class ToolsCollectionView: UICollectionView {
    
    // Коллекция инструментов
    var tools: [Tool]! { didSet { reloadData() } }
    
    open var currentCell: ToolsDrawCell! {
        didSet {
            if let cell = oldValue {
                cell.isSelectedTool = false
            }
        }
        willSet {
            if let cell = newValue {
                cell.isSelectedTool = true
            }
        }
    }
    
    /*
     Градиент от черного к прозрачному.
     За приделами градиента виды обрезаются.
     Используется как маска для CollectionView.
     */
    private let gradientLayer = CAGradientLayer()
    
    /// Отоброжение коллекции
    enum CollectionShows {
        /// Показать все инструменты (ячейки)
        case tools
        /// Выделить один (Одна большая)
        case toolSelected
    }
   
    open var currentStateCollection: CollectionShows = .tools {
        didSet {
            animation(to: currentStateCollection)
        }
    }
    
    var animationCell: UIViewPropertyAnimator!
    
    
    weak var toolsCellDelegate: ToolsCollectionViewDelegate?
    
    weak var toolsCellTouchDelegate: ToolsDrawCellTouchDelegate?
    
    
    // MARK: - init
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.frame = CGRect(
            x: -bounds.width * 0.25,
            y:  -bounds.height * 0.5,
            width: bounds.width * 1.5,
            height: bounds.height * 1.5)
    }
    
    
    
    // MARK: - setup
    
    private func setup() {
        delegate = self
        dataSource = self
        backgroundColor = .clear
        
        gradientLayer.locations = [0.85, 1]
        gradientLayer.colors = [CGColor(gray: 0, alpha: 1), CGColor(gray: 0, alpha: 0)]
        self.layer.mask = gradientLayer
    }
    
    
    
    // MARK: - Touches
    
    private var startWidth: CGFloat!
    private var startTouchLocal: CGPoint!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            startTouchLocal = touch.location(in: self)
            toolsCellTouchDelegate?.startTouch?()
        }
    }
    
    
    // Изменения ширины путем перемещения пальца вверх или вниз по экрану
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard currentCell.isSelectedTool else { return }
        guard currentStateCollection == .tools else { return }
        if let touch = touches.first {
            let currentLocal = touch.location(in: self)
            let distance = (startTouchLocal.y - currentLocal.y)
            guard  abs(distance) > 1 else { return }
            startTouchLocal = currentLocal
            toolsCellTouchDelegate?.beginTouch?(distance.rounded())
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        toolsCellTouchDelegate?.endTouch?()
    }
    
    
    
    
    
    
    
    
    // MARK: - Animation
    
    
    private func animation(to state: CollectionShows) {
        switch state {
        case .tools:
            deselectedAnimation()
        case .toolSelected:
            selectedAnimation()
        }
    }
    
    /// Функция создания анимации выделения инструмента.
    /// Анимация в виде пирамидки
    private func selectedAnimation() {
        let duration = 0.5
        let accelerate = 0.4
        let topTag = currentCell.tag
        let distanceToCenter = bounds.width / 2 - currentCell.frame.origin.x - currentCell.frame.width / 2
        
        // Позиция левый ячеек. Опускает вниз влево. Ускоряя их в зависимости от позиции выбранного
        func leftCell(tag:Int, speed: Double) {
            let left = tag - 1
            if left >= 0 {
                let cell = visibleCells[left]
                cell.transform = CGAffineTransform(translationX: -abs(distanceToCenter) * 1.5, y:  cell.frame.height * speed)
                leftCell(tag: left, speed: speed + accelerate)
            }
        }
        
        // Позиция правых ячеек. Опускает вниз вправо. Ускоряя их в зависимости от позиции выбранного
        func rightCell(tag:Int, speed: Double) {
            let right = tag + 1
            if right < tools.count {
                let cell = visibleCells[right]
                cell.transform = CGAffineTransform(translationX: abs(distanceToCenter) * 1.5, y:  cell.frame.height * speed)
                rightCell(tag: right, speed: speed + accelerate)
            }
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) {
            leftCell(tag: topTag, speed: 1)
            rightCell(tag: topTag, speed: 1)
            
            // анимация выделения (увилечения и перемещения в центр) ячейки
            var transform = CGAffineTransform(translationX: distanceToCenter / 2, y: 0)
            transform = transform.concatenating(CGAffineTransform(scaleX: 2, y: 1.5))
            self.currentCell.transform = transform
        }
    }
    
    
    private func deselectedAnimation() {
        let duration = 0.2
        let time = UISpringTimingParameters(damping: 0.8, response: 1, initialVelocity: CGVector(dx: -5, dy: -5))
        
        
        let animtaion = UIViewPropertyAnimator(duration: duration, timingParameters: time)
        animtaion.addAnimations {
            for cell in self.visibleCells.reversed() {
                cell.transform = .identity
            }
            self.currentCell.transform = .identity
        }
        animtaion.isInterruptible = true
        animtaion.startAnimation()
    }
    
}



// MARK: UICollectionViewDelegate

extension ToolsCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Только в режиме инструменты (tools)
        guard currentStateCollection != .toolSelected else { return }
        let cell = collectionView.cellForItem(at: indexPath) as! ToolsDrawCell
        
        if cell != self.currentCell {
            self.currentCell = cell
            toolsCellDelegate?.selectedNewCell(cell)
        } else {
            if cell.tool is Pen || cell.tool is Eraser {
                toolsCellDelegate?.openWidthTool(cell)
            }
        }
    }
}



// MARK:  UICollectionViewDataSource

extension ToolsCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tools.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "toolCell", for: indexPath) as! ToolsDrawCell
        cell.tool = tools[indexPath.row]
        cell.tag = indexPath.row
        if indexPath.row == 0 {
            self.currentCell = cell
        }
        return cell
    }
}



// MARK: UICollectionViewDelegateFlowLayout

extension ToolsCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 20, height: 88)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return centerCollectionCellLine()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: centerCollectionCellLine(), bottom: 0, right: centerCollectionCellLine())
    }
    
    private func centerCollectionCellLine() -> CGFloat {
        let freeLine = (frame.width - CGFloat(tools.count) * 20) / (CGFloat(tools.count) + 1)
        return freeLine
    }
}

