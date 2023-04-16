//
//  ColorSlidersView.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 16.02.2023.
//

import UIKit


class ColorSlidersView: UIView {

    private let kCONTENT_XIB_NAME = "ColorSlidersView"
    
    @IBOutlet var colorRGBSliders: [ColorGradientSlider]!
    @IBOutlet var colorRGBLabel: [UILabel]!
    @IBOutlet weak var HexTextField: UITextField!
    @IBOutlet var contentView: UIView!
    
    var delegate: ColorObserver?
    
    open var color: UIColor! {
        set {
            rgb = newValue.getComponents()
            setupColor(color: newValue)
        }
        get {
            UIColor(red: rgb[0], green: rgb[1], blue: rgb[2], alpha: rgb[3])
        }
    }
    
    private var rgb:[CGFloat] = []
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    // MARK: - Action
    
    @IBAction func colorChanges(_ sender: ColorGradientSlider) {
        colorRGBLabel[sender.tag].text = NSString(format: "%d", Int(sender.value)) as String
        rgb[sender.tag] = CGFloat(sender.value / 255.0)
        updataColorSlider()
        delegate?.colorChanged()
    }

    
    @IBAction func inputColorHex(_ sender: UITextField) {  }
    
    
    
    // MARK: - Setup
    
    private func setup() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
        setupSliders()
    }
    
    private func setupColor(color: UIColor) {
        setupSliders()
        updataColorSlider()
    }
    
    
    
    // MARK: - Slider
    
    private func setupSliders() {
        colorRGBLabel = colorRGBLabel.sorted { $0.tag < $1.tag }
        colorRGBSliders = colorRGBSliders.sorted { $0.tag < $1.tag }
        for (tag, color) in rgb.enumerated() {
            guard colorRGBSliders.count > tag else { return }
            colorRGBSliders[tag].value = Float(color * 255)
            colorRGBLabel[tag].text = NSString(format: "%d", Int(color * 255.0)) as String
        }
    }
    
    private func updataColorSlider() {
        
        let colors: [(CGFloat)->CGColor] = [
            { CGColor(red:  $0, green: self.rgb[1], blue: self.rgb[2], alpha: 1) },
            { CGColor(red: self.rgb[0], green:  $0, blue: self.rgb[2], alpha: 1) },
            { CGColor(red: self.rgb[0], green: self.rgb[1], blue: $0, alpha: 1) }
        ]
        
        

        let isWhiteThember = colorRGBSliders.contains { slider in
            slider.value > 60
        }
        
        for slider in colorRGBSliders {
            slider.colorsGradient { colors[slider.tag]($0) }
            
            if isWhiteThember {
                slider.colorSetThumbView(CGColor(gray: 0, alpha: 1))
            } else {
                slider.colorSetThumbView(CGColor(gray: 0.2, alpha: 1))
            }
            
        }
    }
    
    
    
    
    // MARK: - Text fild
    
    private func updateHexTextFild() {
        
    }
}


extension UIView {
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}


