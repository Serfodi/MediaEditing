//
//  SettingColorViewController.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 29.01.2023.
//

import UIKit

class SettingColorViewController: UIViewController {
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var heightMenuViewConstraint: NSLayoutConstraint!
    
    @IBOutlet var colorRGBSliders: [UISlider]!
    @IBOutlet var colorRGBLabel: [UILabel]!
    
    
    var settingColorRGB:SettingColorRGB!
    var colorRGB:[CGFloat] = []
    
    
    // MARK: - UIViewController / Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
        colorRGB.append(settingColorRGB.red)
        colorRGB.append(settingColorRGB.green)
        colorRGB.append(settingColorRGB.blue)
        
        for (tag, color) in colorRGB.enumerated() {
            colorRGBSliders[tag].value = Float(color * 255)
            colorRGBLabel[tag].text = NSString(format: "%d", Int(color * 255.0)) as String
        }
    }
    
    
    // MARK: - Action
    
    @IBAction func colorChanges(_ sender: UISlider) {
        colorRGBLabel[sender.tag].text = NSString(format: "%d", Int(sender.value)) as String
        colorRGB[sender.tag] = CGFloat(sender.value / 255.0)
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        settingColorRGB.red = colorRGB[0]
        settingColorRGB.green = colorRGB[1]
        settingColorRGB.blue = colorRGB[2]
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
    
}
