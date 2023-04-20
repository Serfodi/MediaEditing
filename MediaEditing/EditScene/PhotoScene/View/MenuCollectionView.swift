//
//  MenuCollectionView.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 15.04.2023.
//

import UIKit

class MenuCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    struct MenuItem {
        let name: String
        let imageName: String
    }
    
    var menuItems: [MenuItem] = [] {
        didSet {
            reloadData()
        }
    }
    
    private var bluerView: UIVisualEffectView = {
        let bluerView = UIVisualEffectView()
        let bluerEffect = UIBlurEffect(style: .dark)
        bluerView.effect = bluerEffect
        return bluerView
    }()
    
    
    override func draw(_ rect: CGRect) {
        backgroundColor = UIColor(white: 29 / 255, alpha: 0.94)
        bluerView.frame = bounds
        addSubview(bluerView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = MenuItemcCell()
        cell.menuItem = menuItems[indexPath.row]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bounds.width, height: 44)
    }
    
}



class MenuItemcCell: UICollectionViewCell {
    
    open var menuItem: MenuCollectionView.MenuItem! {
        didSet {
            label.text = menuItem.name
            if let image = UIImage(named: menuItem.imageName) {
                imageView.image = image
            }
            stackView.layoutSubviews()
        }
    }
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SF-Pro-Text-Semibold", size: 17)
        label.textColor = .white
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 24, height: 24)))
        return imageView
    }()
    
    private var stackView: UIStackView = UIStackView(arrangedSubviews: [])
    
    
    override func draw(_ rect: CGRect) {
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 12).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 16).isActive = true
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(imageView)
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
}
