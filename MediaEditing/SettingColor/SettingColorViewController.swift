//
//  SettingColorViewController.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 29.01.2023.
//

import UIKit

class SettingColorViewController: UIViewController {
    
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet var colorRGBSliders: [ColorGradientSlider]!
    @IBOutlet var colorRGBLabel: [UILabel]!
    
    
    @IBOutlet weak var opacityLabel: UILabel!
    @IBOutlet weak var opacitySlider: ColorOpacitySlider!
    
    @IBOutlet weak var HexTextField: UITextField!
    
    
    @IBOutlet weak var colorView: UIView!
    
    
    var settingColorRGB:SettingColorRGB!
    var colorRGB:[CGFloat] = []
    
    var opacity: CGFloat!
    
    // MARK: - UIViewController / Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
        colorRGBLabel = colorRGBLabel.sorted { $0.tag < $1.tag }
        colorRGBSliders = colorRGBSliders.sorted { $0.tag < $1.tag }
        
        colorRGB.append(settingColorRGB.red)
        colorRGB.append(settingColorRGB.green)
        colorRGB.append(settingColorRGB.blue)
        for (tag, color) in colorRGB.enumerated() {
            colorRGBSliders[tag].value = Float(color * 255)
            colorRGBLabel[tag].text = NSString(format: "%d", Int(color * 255.0)) as String
        }
        
        
        opacity = settingColorRGB.opacity
        opacitySlider.value = Float(opacity * 100)
        opacityLabel.text = NSString(format: "%d", Int(opacity * 100.0)) as String
     
        updataSlider()
        
    }
    
    
    // MARK: - Action
    
    @IBAction func colorChanges(_ sender: ColorGradientSlider) {
        colorRGBLabel[sender.tag].text = NSString(format: "%d", Int(sender.value)) as String
        colorRGB[sender.tag] = CGFloat(sender.value / 255.0)
        updataSlider()
    }

    @IBAction func opacityChanges(_ sender: ColorOpacitySlider) {
        opacityLabel.text = NSString(format: "%d", Int(sender.value)) as String
        opacity = CGFloat(sender.value / 100.0)
        
    }
    
    @IBAction func inputColorHex(_ sender: UITextField) {
        
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        settingColorRGB.red = colorRGB[0]
        settingColorRGB.green = colorRGB[1]
        settingColorRGB.blue = colorRGB[2]
        settingColorRGB.opacity = opacity
    }
    
    
    // MARK: - Set Up View
    
    func setUpView() {
        let bluerView = UIVisualEffectView()
        
        let bluerEffect = UIBlurEffect(style: .dark)
        bluerView.frame = view.frame
        bluerView.effect = bluerEffect
        
        let path = UIBezierPath(roundedRect: bluerView.frame, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 15, height: 10))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        bluerView.layer.mask = mask
        
        menuView.insertSubview(bluerView, at: 0)
    }
    
    
    func updataSlider() {
        let colors: [(Int)->CGColor] = [
            { CGColor(red: self.colorRGB[0] * CGFloat($0), green: self.colorRGB[1], blue: self.colorRGB[2], alpha: 1) },
            { CGColor(red: self.colorRGB[0], green: self.colorRGB[1] * CGFloat($0), blue: self.colorRGB[2], alpha: 1) },
            { CGColor(red: self.colorRGB[0], green: self.colorRGB[1], blue: self.colorRGB[2] * CGFloat($0), alpha: 1) }
        ]
        for slider in colorRGBSliders { slider.colorsGradient { colors[slider.tag]($0) } }
        
        let colorOpacity: (Int) -> CGColor = {
            CGColor(red: self.colorRGB[0], green: self.colorRGB[1], blue: self.colorRGB[2], alpha: self.opacity * CGFloat($0))
        }
        opacitySlider.colorsGradient(colorOpacity)
        
        colorView.backgroundColor = UIColor(cgColor: CGColor(red: self.colorRGB[0], green: self.colorRGB[1], blue: self.colorRGB[2], alpha: self.opacity))
        
    }
    
    
    func updateHexTextFild() {
        
    }
    
    
}
