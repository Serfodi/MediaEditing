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
    
}

class ToolsCollectionView: UICollectionView {
    
    enum State {
        case selected
        case deselected
    }
    
    open var tools: [Tool] = [] {
        didSet { reloadData() }
    }
    
    open var currentCell: ToolsDrawCell! { get { return cell } }
    private var cell: ToolsDrawCell! {
        didSet {
            if let cell = oldValue{
                cell.frame.origin.y = 16
            }
        }
        willSet {
            if let cell = newValue {
                cell.frame.origin.y = 0
            }
        }
    }
    
    open var currentState: State { get { return state } }
    private var state: State = .deselected
    
    private var collectionViewFlowLayout = UICollectionViewFlowLayout()
    
    open var toolsCollectionViewDelegate: ToolsCollectionViewDelegate?
    
    // MARK: init
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    
    
    // MARK: setup
    
    private func setup() {
        delegate = self
        dataSource = self
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        backgroundColor = .clear
    }
    
    
    // MARK: Animation
    
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
                cell.transform = CGAffineTransform(translationX: -abs(distanceToCenter), y:  cell.frame.height * speed)
                leftCell(tag: left, speed: speed + accelerate)
            }
        }
        
        func rightCell(tag:Int, speed: Double) {
            let right = tag + 1
            if right < tools.count {
                let cell = visibleCells[right]
                cell.transform = CGAffineTransform(translationX: abs(distanceToCenter), y:  cell.frame.height * speed)
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
        
        let duration = 0.5
        
        UIView.animate(withDuration: duration, delay: 0) {
            for cell in self.visibleCells {
                cell.transform = .identity
            }
            self.cell.transform = .identity
        }
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
        cell.frame.origin.y = 16
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
        return UIEdgeInsets(top: 0, left: centerCollectionCellLine(), bottom: 0, right: centerCollectionCellLine())
    }
    
    private func centerCollectionCellLine() -> CGFloat {
        let freeLine = (frame.width - CGFloat(tools.count) * 20) / (CGFloat(tools.count) + 1)
        return freeLine
    }
}
