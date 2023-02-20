//
//  ColorSlidersView.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 16.02.2023.
//

import UIKit


protocol ColorDelegate: AnyObject {
    
    func colorChanged()
    
}



class ColorSlidersView: UIView {

    
    private let kCONTENT_XIB_NAME = "ColorSlidersView"
    
    weak var colorDelegate: ColorDelegate?
    
    @IBOutlet var colorRGBSliders: [ColorGradientSlider]!
    @IBOutlet var colorRGBLabel: [UILabel]!

    @IBOutlet weak var HexTextField: UITextField!
   
    @IBOutlet var contentView: UIView!
    
    
    open var colorRGB:[CGFloat] = []
    
    open var settingColorRGB:SettingColorRGB!
    
    

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
        colorRGB[sender.tag] = CGFloat(sender.value / 255.0)
        updataColorSlider()
        colorDelegate?.colorChanged()
    }

    
    @IBAction func inputColorHex(_ sender: UITextField) {  }
    
    
    
    // MARK: - Setup
    
    private func setup() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
        
        setupSliders()
    }
    
    open func setupColor(color: SettingColorRGB) {
        settingColorRGB = color
        colorRGB.append(settingColorRGB.red)
        colorRGB.append(settingColorRGB.green)
        colorRGB.append(settingColorRGB.blue)
        setupSliders()
        updataColorSlider()
    }
    
    
    
    // MARK: - Slider
    
    open func setupSliders() {
        colorRGBLabel = colorRGBLabel.sorted { $0.tag < $1.tag }
        colorRGBSliders = colorRGBSliders.sorted { $0.tag < $1.tag }
        for (tag, color) in colorRGB.enumerated() {
            colorRGBSliders[tag].value = Float(color * 255)
            colorRGBLabel[tag].text = NSString(format: "%d", Int(color * 255.0)) as String
        }
    }
    
    open func updataColorSlider() {
        let colors: [(Int)->CGColor] = [
            { CGColor(red: self.colorRGB[0] * CGFloat($0), green: self.colorRGB[1], blue: self.colorRGB[2], alpha: 1) },
            { CGColor(red: self.colorRGB[0], green: self.colorRGB[1] * CGFloat($0), blue: self.colorRGB[2], alpha: 1) },
            { CGColor(red: self.colorRGB[0], green: self.colorRGB[1], blue: self.colorRGB[2] * CGFloat($0), alpha: 1) }
        ]
        for slider in colorRGBSliders { slider.colorsGradient { colors[slider.tag]($0) } }
    }
    
    
    // MARK: - Text fild
    
    private func updateHexTextFild() {
        
    }
    
}


extension UIView
{
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


