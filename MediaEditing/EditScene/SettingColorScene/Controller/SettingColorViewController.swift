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
    @IBOutlet weak var opacitySlider: ColorGradientSlider!
    @IBOutlet weak var colorSegmentedController: UISegmentedControl!
    @IBOutlet weak var colorContainerView: UIView!
    @IBOutlet weak var colorView: ColorView!
    
    var colorGridView: ColorGridCollectionView!
    var colorSpectrumView: ColorSpectrumView!
    var colorSliderView: ColorSlidersView!
    
    var delegate: ColorObserver!
    
    open var dataModelController: DataModelController!
    
    private var color: UIColor!
    
    
    // MARK: - UIViewController / Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let color = dataModelController.getCurrentColor() {
            self.color = color
        } else {
            color = UIColor(white: 1, alpha: 1)
        }
        
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
    
    
    
    // MARK: - Segue
        
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if dataModelController.currentTool is Pen {
            delegate.colorChanged(color)
        } else {
            delegate.colorChanged(nil)
        }
    }

    
    
    
    // MARK: - Action
    
    @IBAction func opacityChanges(_ sender: ColorGradientSlider) {
        opacityLabel.text = NSString(format: "%d", Int(sender.value)) as String
        color = color.withAlphaComponent(CGFloat(sender.value / 100.0))
        updataColor()
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
            colorSliderView.setColor(color)
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
        opacityLabel.clipsToBounds = true
        opacitySlider.backgroundColor = renderCheckerboardPattern(colors:
                                                                    (dark: UIColor(white: 1, alpha: 0.5),
                                                                     light: UIColor(white: 0, alpha: 0)),
                                                                  height: opacitySlider.bounds.height)
        opacitySlider.layer.cornerRadius = opacitySlider.bounds.height / 2
    }
    
    private func setupBlureBG() {
        let bluerView = UIVisualEffectView()
        let bluerEffect = UIBlurEffect(style: .dark)
        bluerView.frame = view.bounds
        bluerView.effect = bluerEffect
        
        let path = UIBezierPath(roundedRect: bluerView.frame, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 15, height: 10))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        bluerView.layer.mask = mask
        
        menuView.insertSubview(bluerView, at: 0)
    }
    
    
    private func setupColorView() {}
    
    
    // MARK: - renderCheckerboardPattern
    
    
    private func renderCheckerboardPattern(colors: (dark: UIColor, light: UIColor), height:CGFloat) -> UIColor {
        let size = height/3
        let image = UIGraphicsImageRenderer(size: CGSize(width: size * 2, height: size * 2)).image { context in
            colors.dark.setFill()
            context.fill(CGRect(x: 0, y: 0, width: size * 2, height: size * 2))
            colors.light.setFill()
            context.fill(CGRect(x: size, y: 0, width: size, height: size))
            context.fill(CGRect(x: 0, y: size, width: size, height: size))
        }
        return UIColor(patternImage: image)
    }
    
    
    
    
    
    // MARK: - updata
    
    func updataColor() {
        updataColorView(color: color)
        updataSlider(color: color)
        colorSliderView.setColor(color)
    }
    
    
    
    // MARK: - updata Slider
    
    private func updataSlider(color: UIColor) {
        guard opacitySlider != nil else { return }
        opacitySlider.colorsGradient(colors: [color.withAlphaComponent(0).cgColor, color.withAlphaComponent(1).cgColor])
        opacitySlider.colorSetThumbView(color: color)
    }
    
    // MARK: - updata color View
    
    private func updataColorView(color: UIColor) {
        guard colorView != nil else { return }
        colorView.color = color
    }
}


protocol ColorObserver: AnyObject {
    
    func colorChanged(_ color: UIColor?)
}


extension SettingColorViewController: ColorObserver {
    
    func colorChanged(_ color: UIColor?) {
        switch colorSegmentedController.selectedSegmentIndex {
        case 0:
            if let color = colorGridView.colorSelected {
                self.color = color
                updataColor()
            }
        case 1:
            if let color = colorSpectrumView.selectedColor {
                self.color = color
                updataColor()
            }
        case 2:
            if let color = colorSliderView.getColor() {
                self.color = color
                updataColorView(color: color)
                updataSlider(color: color)
            }
        default: return
        }
    }
}

