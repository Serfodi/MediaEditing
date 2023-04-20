//
//  ToolsCollectionView.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 27.02.2023.
//

import UIKit


protocol ToolsCollectionViewDelegate: AnyObject {
    
    func cellTap()
    func cellWidht()
    
    func startTouch()
    func beginTouch(widht: CGFloat)
    func endTouch()
    
}


class ToolsCollectionView: UICollectionView {
    
    enum State {
        case selected
        case deselected
    }
    
    private let selectTool: [State:Double] = [ .selected: -16, .deselected: 16]
    
    private let gradientLayer = CAGradientLayer()
    
    open var tools: [Tool] = [] {
        didSet {
            reloadData()
        }
    }
    
    open var currentTool: Tool! {
        get {
            if let cell = cell {
                return cell.tool
            } else {
                return nil
            }
        }
    }
    open var currentCell: ToolsDrawCell! { get { cell } }
    
    private var cell: ToolsDrawCell! {
        didSet {
            if let cell = oldValue {
                selectToolAnimation(.deselected, cell: cell)
            }
        }
        willSet {
            if let cell = newValue {
                selectToolAnimation(.selected, cell: cell)
            }
        }
    }
    
    open var currentState: State { get { return state } }
    
    private var state: State = .deselected
    
    private var collectionViewFlowLayout = UICollectionViewFlowLayout()
    
    open var toolsCollectionViewDelegate: ToolsCollectionViewDelegate?
    
    open var toolsAnimation = UIViewPropertyAnimator()
    
    
    private var startTouchLocal: CGPoint!
    
    
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
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            startTouchLocal = touch.location(in: cell)
            toolsCollectionViewDelegate?.startTouch()
        }
    }
    
    let oldWidth: Float = 0.0
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard currentState == .deselected else { return }
        guard cell.tool.widht != nil else { return }
        if let touch = touches.first {
            let currentLocal = touch.location(in: cell)
            
            let distance = (startTouchLocal.y - currentLocal.y)
            startTouchLocal = currentLocal
            
            let deltaWidth = distance / 24.0 * 3
            
            let newWidth = CGFloat(cell.tool.widht) + deltaWidth
            
            if newWidth >= 4 && newWidth <= 24 {
                cell.setWidth(newWidth)
                toolsCollectionViewDelegate?.beginTouch(widht: newWidth)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        toolsCollectionViewDelegate?.endTouch()
    }
    
    
    // MARK: - Animation
    
    
    open func animation(to state: State) {
        self.state = state
        switch state {
        case .selected:
            selectedAnimation()
        case .deselected:
            deselectedAnimation()
        }
    }
    
    
    private func selectedAnimation() {
        let duration = 0.5
        let accelerate = 0.4
        let topTag = cell.tag
        let distanceToCenter = bounds.width / 2 - cell.frame.origin.x - cell.frame.width / 2
        
        func leftCell(tag:Int, speed: Double) {
            let left = tag - 1
            if left >= 0 {
                let cell = visibleCells[left]
                cell.transform = CGAffineTransform(translationX: -abs(distanceToCenter) * 1.5, y:  cell.frame.height * speed)
                leftCell(tag: left, speed: speed + accelerate)
            }
        }
        
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
            
            // анимация выделения ячейки
            var transform = CGAffineTransform(translationX: distanceToCenter / 2, y: 0)
            transform = transform.concatenating(CGAffineTransform(scaleX: 2, y: 1.5))
            self.cell.transform = transform
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
            self.cell.transform = .identity
        }
        animtaion.isInterruptible = true
        animtaion.startAnimation()
    }
    
    
    private func selectToolAnimation(_ state: State, cell: UICollectionViewCell) {
        let duration = 0.05
        let time = UISpringTimingParameters(damping: 0.5, response: 0.3)
        
        let animtaion = UIViewPropertyAnimator(duration: duration, timingParameters: time)
        animtaion.addAnimations {
            cell.frame.origin.y += self.selectTool[state]!
        }
        animtaion.isInterruptible = true
        animtaion.startAnimation()
    }
    
}


// MARK: UICollectionViewDelegate

extension ToolsCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ToolsDrawCell
        if cell != self.cell {
            self.cell = cell
        } else {
            toolsCollectionViewDelegate?.cellWidht()
        }
        toolsCollectionViewDelegate?.cellTap()
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
            self.cell = cell
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
