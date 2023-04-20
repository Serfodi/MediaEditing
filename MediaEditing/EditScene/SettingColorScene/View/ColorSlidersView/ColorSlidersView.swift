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
    @IBOutlet var colorRGBField: [UITextField]!
    @IBOutlet weak var hexTextField: UITextField!
    @IBOutlet var contentView: UIView!
    
    var delegate: ColorObserver?
    
    private var color: UIColor! {
        set {
            rgba = newValue.getComponents()
        }
        get {
            if let color = UIColor.init(rgba: rgba) {
                return color
            }
            return UIColor(white: 0, alpha: 0)
        }
    }
    private var rgba:[CGFloat] = []
    
    
    
    // MARK: - init / Life Cycle
    
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
        rgba[sender.tag] = CGFloat(sender.value / 255.0)
        
        sliderValueUpdate()
        colorSlidersUpdate()
        hexTextFildUpdate()
        
        delegate?.colorChanged()
    }

    
    @IBAction func inputColorHex(_ sender: UITextField) {}

    
    
    // MARK: - Setup
    
    private func setup() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
        let veiw = UIView(frame: bounds)
        veiw.backgroundColor = .green
        
        hexTextField.delegate = self
        
        setupTextFild()
        setupSliders()
    }
    
    private func setupTextFild() {
        for textFild in colorRGBField {
            textFild.addDoneCancelToolbar()
        }
    }
    
    private func setupSliders() {
        colorRGBField = colorRGBField.sorted { $0.tag < $1.tag }
        colorRGBSliders = colorRGBSliders.sorted { $0.tag < $1.tag }
        sliderValueUpdate()
    }
    
    
    // MARK: - Updata Color
    
    open func setColor(_ color: UIColor) {
        self.color = color
        sliderValueUpdate()
        colorSlidersUpdate()
        hexTextFildUpdate()
    }
    
    open func getColor() -> UIColor! {
        return color
    }
    
    
    
    
    // MARK:  Slider
    
    
    private func sliderValueUpdate() {
        for (tag, color) in rgba.enumerated() {
            guard colorRGBSliders.count > tag else { return }
            colorRGBSliders[tag].value = Float(color * 255)
            colorRGBField[tag].text = NSString(format: "%d", Int(color * 255.0)) as String
        }
    }
    // перенести
    private func colorSlidersUpdate() {
        
        let colors: [(CGFloat)->CGColor] = [
            { CGColor(red:  $0, green: self.rgba[1], blue: self.rgba[2], alpha: 1) },
            { CGColor(red: self.rgba[0], green:  $0, blue: self.rgba[2], alpha: 1) },
            { CGColor(red: self.rgba[0], green: self.rgba[1], blue: $0, alpha: 1) }
        ]
        
        for slider in colorRGBSliders {
            slider.colorsGradient(colors: [colors[slider.tag](0), colors[slider.tag](1)])
            slider.colorSetThumbView(color: color)
        }
    }
    
    
    // MARK:  Text fild
    
    private func hexTextFildUpdate() {
        hexTextField.text = UIColor.hexConvert(red: rgba[0], green: rgba[1], blue: rgba[2])
    }
    
}



// MARK: - UITextFieldDelegate


extension ColorSlidersView: UITextFieldDelegate {
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField.tag {
        case 0...2:
            if let float = Float(textField.text ?? "") {
                let component = float / 255.0
                guard component >= 0 && component <= 1 else { return }
                rgba[textField.tag] = CGFloat(component)
                sliderValueUpdate()
                colorSlidersUpdate()
                delegate?.colorChanged()
            }
        case 3:
            if let color = UIColor(hex: textField.text ?? "0") {
                rgba = color.getComponents()
                sliderValueUpdate()
                colorSlidersUpdate()
                delegate?.colorChanged()
            }
        default:
            return
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.tag {
        case 0...2:
            if string == "" {
                return true
            } else {
                return textField.text?.count ?? 0 < 3
            }
        case 3:
            if string == "" {
                return true
            } else {
                var rgb: UInt64 = 0
                return Scanner(string: string).scanHexInt64(&rgb) && textField.text?.count ?? 0 < 6
            }
        default:
            return false
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0...2:
            colorSlidersUpdate()
            hexTextFildUpdate()
            sliderValueUpdate()
        case 3:
            hexTextFildUpdate()
            sliderValueUpdate()
            colorSlidersUpdate()
        default: return
        }
    }
        
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension UIView {
    func fixInView(_ container: UIView!) -> Void {
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}


extension UITextField {
    
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil) {
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))

        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()

        self.inputAccessoryView = toolbar
    }

    @objc func doneButtonTapped() { self.resignFirstResponder() }
}
