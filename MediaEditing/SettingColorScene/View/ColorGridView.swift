//
//  ColorGridView.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 11.02.2023.
//

import UIKit

class ColorGridCollectionView: UIView {

    private let colomns = 12
    private let rows = 10
    
    var delegate: ColorObserver?
    
    open  var colorSelected: UIColor!
    private var currectCell: UICollectionViewCell!
    private var currentIndex: Int = 0
    
    private lazy var selectedShape: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.cornerRadius = 3
        layer.borderWidth = 3
        layer.borderColor = UIColor.white.cgColor
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
    
    private var colors:[UIColor] = []
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK:  draw
    
    override func draw(_ rect: CGRect) {
        setupView()
        layer.addSublayer(selectedShape)
    }
    
    
    // MARK:  - setup
    
    private func setup() {
        colorsSurse()
        colorSelected = colors[0]
    }
    
    
    // MARK:  - setup Veiw
    
    private func setupView() {
        backgroundColor = .clear
        layer.cornerRadius = 10
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview!.topAnchor,  constant: 0),
            bottomAnchor.constraint(equalTo: superview!.bottomAnchor),
            leadingAnchor.constraint(equalTo: superview!.leadingAnchor,  constant: 0),
            rightAnchor.constraint(equalTo: superview!.rightAnchor),
        ])
        
        let layout = UICollectionViewFlowLayout()
        let width = frame.width / CGFloat(colomns)
        let height = frame.height / CGFloat(rows)
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collection = UICollectionView(frame: frame, collectionViewLayout: layout)
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collection.layer.cornerRadius = 10
        collection.backgroundColor = .clear
        
        collection.dataSource = self
        collection.delegate = self
        
        addSubview(collection)
        
        collection.clipsToBounds = true
    }
    
    
    
    // MARK:   color arrray
    
    private func colorsSurse() {
        for row in 0..<rows {
            for colomn in 0..<colomns {
                switch row {
                case 0:
                    let brightness = 1.0 / Double(colomns - 1) * CGFloat(colomn)
                    let color = UIColor(hue: 0, saturation: 0, brightness: 1 - brightness, alpha: 1)
                    colors.append(color)
                case 1..<rows:
                    let step = 333.0 / CGFloat(colomns)
                    let hue = (4.0 + step * CGFloat(colomn)) / 360
                    let saturation = 0.95
                    let lightness = 1.0 / CGFloat(rows) * CGFloat(row)
                    let color = UIColor(hue: hue, saturation: saturation, lightness: lightness, alpha: 1)
                    colors.append(color)
                default: return
                }
                
            }
        }
    }
    
}


// MARK: - UICollectionViewDataSource

extension ColorGridCollectionView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if indexPath.row == currentIndex { selectedShape.frame = cell.frame }
        cell.backgroundColor = colors[indexPath.row]
        
        return cell
    }
    
}


// MARK: - UICollectionViewDelegate

extension ColorGridCollectionView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        selectedShape.frame = cell!.frame
        currectCell = cell
        colorSelected = colors[indexPath.row]
        delegate?.colorChanged()
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}
