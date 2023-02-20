//
//  SettingColorViewController.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 29.01.2023.
//

import UIKit

class SettingColorViewController: UIViewController {
    
    @IBOutlet weak var menuView: UIView!
    
    
    @IBOutlet weak var opacityLabel: UILabel!
    @IBOutlet weak var opacitySlider: ColorOpacitySlider!
    
    
    @IBOutlet weak var colorSegmentedController: UISegmentedControl!
    
    @IBOutlet weak var colorContainerView: UIView!
    
    @IBOutlet weak var colorView: UIView!
    
    
    var colorGridView: ColorGridCollectionView!
    var colorSpectrumView: ColorSpectrumView!
    var colorSliderView: ColorSlidersView!
    
    
    var settingColorRGB:SettingColorRGB!
    var colorRGB:[CGFloat] = []
    
    var opacity: CGFloat!
    
    
    // MARK: - UIViewController / Life Cycle
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        colorGridView.delegate = self
        colorSpectrumView.delegate = self
        colorSliderView.colorDelegate = self
        updataSlider()
    }
    
    
    override func viewWillLayoutSubviews() {
        colorGridView.frame = colorContainerView.bounds
        colorSpectrumView.frame = colorContainerView.bounds
        colorSliderView.frame = colorContainerView.bounds
    }
    
    
    
    
    // MARK: - Action
    
    @IBAction func opacityChanges(_ sender: ColorOpacitySlider) {
        opacityLabel.text = NSString(format: "%d", Int(sender.value)) as String
        opacity = CGFloat(sender.value / 100.0)
        
    }
    
    @IBAction func paletteSelection(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            colorContainerView.bringSubviewToFront(colorGridView)
            colorGridView.isHidden = false
            colorSpectrumView.isHidden = true
            colorSliderView.isHidden = true
        case 1:
            colorContainerView.bringSubviewToFront(colorSpectrumView)
            colorGridView.isHidden = true
            colorSpectrumView.isHidden = false
            colorSliderView.isHidden = true
        case 2:
            colorContainerView.bringSubviewToFront(colorSliderView)
            colorGridView.isHidden = true
            colorSpectrumView.isHidden = true
            colorSliderView.isHidden = false
        default:
            break
        }
    }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "closeSettingColorVC":
            settingColorRGB.red = colorRGB[0]
            settingColorRGB.green = colorRGB[1]
            settingColorRGB.blue = colorRGB[2]
            settingColorRGB.opacity = opacity
        default: break
        }
    }
    
    
    
    // MARK: - Setup View
    
    func setupView() {
        setupBlureBG()
        setupColor()
        setupColorGridView()
        setupColorSpectrumView()
        setupColorSliderView()
        setupOpacitySlider()
    }
    
    func setupColor() {
        colorRGB = []
        colorRGB.append(settingColorRGB.red)
        colorRGB.append(settingColorRGB.green)
        colorRGB.append(settingColorRGB.blue)
    }
    
    func setupColorGridView() {
        colorGridView = ColorGridCollectionView()
        colorContainerView.addSubview(colorGridView)
    }
    
    func setupColorSpectrumView() {
        colorSpectrumView = ColorSpectrumView()
        colorContainerView.addSubview(colorSpectrumView)
        colorSpectrumView.isHidden = true
    }
    
    func setupColorSliderView() {
        colorSliderView = ColorSlidersView()
        colorSliderView.setupColor(color: settingColorRGB)
        colorContainerView.addSubview(colorSliderView)
        colorSliderView.isHidden = true
    }
    
    func setupOpacitySlider() {
        opacity = settingColorRGB.opacity
        opacitySlider.value = Float(opacity * 100)
        opacityLabel.text = NSString(format: "%d", Int(opacity * 100.0)) as String
    }
    
    func setupBlureBG() {
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
    
    
    // MARK: - Slider
    
    func updataSlider() {
        let colorOpacity: (Int) -> CGColor = {
            CGColor(red: self.colorRGB[0], green: self.colorRGB[1], blue: self.colorRGB[2], alpha: self.opacity * CGFloat($0))
        }
        opacitySlider.colorsGradient(colorOpacity)
        
        colorView.backgroundColor = UIColor(cgColor: CGColor(red: self.colorRGB[0], green: self.colorRGB[1], blue: self.colorRGB[2], alpha: self.opacity))
    }
    
}

extension SettingColorViewController: ColorDelegate {
    
    func colorChanged() {
        
        switch colorSegmentedController.selectedSegmentIndex {
        case 0:
            if let color = colorGridView.colorSelected.cgColor.components {
                colorRGB = [color[0], color[1], color[2]]
                colorSliderView.colorRGB = colorRGB
                colorSliderView.updataColorSlider()
                colorSliderView.setupSliders()
                updataSlider()
            }
        case 1:
            if let color = colorSpectrumView.selectedColor.cgColor.components {
                colorRGB = [color[0], color[1], color[2]]
                updataSlider()
                colorSliderView.colorRGB = colorRGB
                colorSliderView.updataColorSlider()
                colorSliderView.setupSliders()
            }
        case 2:
            colorRGB = colorSliderView.colorRGB
            updataSlider()
        default: return
        }
    }
    
    
    
}
