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
    
    open var color: UIColor!
    
    
    // MARK: - UIViewController / Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        colorGridView.delegate = self
        colorSpectrumView.delegate = self
        colorSliderView.delegate = self
        updataColor()
    }
    
    override func viewWillLayoutSubviews() {
        colorGridView.frame = colorContainerView.bounds
        colorSpectrumView.frame = colorContainerView.bounds
        colorSliderView.frame = colorContainerView.bounds
    }
    
    
    // MARK: - Action
    
    @IBAction func opacityChanges(_ sender: ColorOpacitySlider) {
        opacityLabel.text = NSString(format: "%d", Int(sender.value)) as String
        color = color.withAlphaComponent(CGFloat(sender.value / 100.0))
    }
    
    @IBAction func paletteSelection(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            colorContainerView.bringSubviewToFront(colorGridView)
            colorGridView.colorSelected = color
            colorGridView.isHidden = false
            colorSpectrumView.isHidden = true
            colorSliderView.isHidden = true
        case 1:
            colorContainerView.bringSubviewToFront(colorSpectrumView)
            colorSpectrumView.selectedColor = color
            colorGridView.isHidden = true
            colorSpectrumView.isHidden = false
            colorSliderView.isHidden = true
        case 2:
            colorContainerView.bringSubviewToFront(colorSliderView)
            colorSliderView.color = color
            colorGridView.isHidden = true
            colorSpectrumView.isHidden = true
            colorSliderView.isHidden = false
        default:
            break
        }
        updataColor()
    }
    
    
    // MARK: - Setup View
    
    private func setupView() {
        setupBlureBG()
        setupColorGridView()
        setupColorSpectrumView()
        setupColorSliderView()
        setupOpacitySlider()
    }
    
    private func setupColorGridView() {
        colorGridView = ColorGridCollectionView()
        colorContainerView.addSubview(colorGridView)
    }
    
    private func setupColorSpectrumView() {
        colorSpectrumView = ColorSpectrumView()
        colorContainerView.addSubview(colorSpectrumView)
        colorSpectrumView.isHidden = true
    }
    
    private func setupColorSliderView() {
        colorSliderView = ColorSlidersView()
        colorContainerView.addSubview(colorSliderView)
        colorSliderView.isHidden = true
    }
    
    private func setupOpacitySlider() {
        opacitySlider.value = Float(color.cgColor.alpha * 100)
        opacityLabel.text = NSString(format: "%d", Int(color.cgColor.alpha * 100.0)) as String
    }
    
    private func setupBlureBG() {
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
    
    // MARK: - updata
    
    func updataColor() {
        updataColorView(color: color)
        updataSlider(color: color)
    }
    
    
    
    // MARK: - updata Slider
    
    private func updataSlider(color: UIColor) {
        guard opacitySlider != nil else { return }
        opacitySlider.colorsGradient(color: color)
    }
    
    // MARK: - updata color View
    
    private func updataColorView(color: UIColor) {
        guard colorView != nil else { return }
        colorView.backgroundColor = color
    }
}


protocol ColorObserver: AnyObject {
    
    func colorChanged()
}

extension SettingColorViewController: ColorObserver {
    
    func colorChanged() {
        switch colorSegmentedController.selectedSegmentIndex {
        case 0:
            if let color = colorGridView.colorSelected {
                self.color = color
            }
        case 1:
            if let color = colorSpectrumView.selectedColor {
                self.color = color
            }
        case 2:
            if let color = colorSliderView.color {
                self.color = color
            }
        default: return
        }
        updataColor()
    }
}

