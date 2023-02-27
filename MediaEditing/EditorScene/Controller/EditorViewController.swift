//
//  EditorViewController.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 11.01.2023.
//

import UIKit
import Photos
import PhotosUI
import Lottie


class EditorViewController: UIViewController {
    
    enum AnimationWidhtTool {
        case tools
        case width
    }
    
    var asset: PHAsset!
    
    @IBOutlet weak var imageScrollView: ImageScrollView!
    
    @IBOutlet weak var toolBarView: UIView!
    
    @IBOutlet weak var zoomView: UIStackView!
    @IBOutlet weak var segmentedControl: SegmentSliderView!
    
    @IBOutlet weak var downloadButton: DownnloadToRoundView!
    
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var clearAllButton: UIButton!
    @IBOutlet weak var colorPickerButton: ColorPickerButton!
    
    // Содержит набор инструментов
    @IBOutlet weak var toolseCollectionView: ToolsCollectionView!
    
    @IBOutlet weak var backToCancelButtonView: BackToCancelButton!
    
    @IBOutlet weak var addButton: UIButton!
    
    var animationWidhtTool: AnimationWidhtTool = .tools
    
    @IBOutlet weak var widhtButtonConstraint: NSLayoutConstraint!
    
    
    
    // Набор инструментов
    private let tools = [
        Tool(toolName: .pen, color: SettingColorRGB(red: 1, green: 1, blue: 1, opacity: 1), widht: 14),
        Tool(toolName: .brush, color: SettingColorRGB(red: 6/255, green: 248/255, blue: 98/255, opacity: 1), widht: 18),
        Tool(toolName: .brush, color: SettingColorRGB(red: 248/255, green: 22/255, blue: 6/255, opacity: 1), widht: 4),
        Tool(toolName: .pencil, color: SettingColorRGB(red: 251/255, green: 249/255, blue: 105/255, opacity: 1), widht: 24),
        Tool(toolName: .lasso),
        Tool(toolName: .eraser)
    ]
    
    
    
    // MARK: - UIViewController / Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PHPhotoLibrary.shared().register(self)
        
        setupImageScrollView()
        
        toolseCollectionView.tools = tools
        toolseCollectionView.toolsCollectionViewDelegate = self
        
        segmentedControl.slider.delegate = self
        backToCancelButtonView.delegate = self
        
        segmentedControl.slider.maximumValue = 24
        segmentedControl.slider.minimumValue = 4
        segmentedControl.slider.value = 14
        
        
        
        colorUp(RGB: imageScrollView.settingColorRGB)
    }
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateImage()
    }
    
    
    // MARK: - Action
    
    
    // Navigation bar
    @IBAction func undo(_ sender: UIButton) {
        imageScrollView.undo()
    }
    
    @IBAction func clearAll(_ sender: UIButton) {
        imageScrollView.clearAll()
    }
    
    
    
    // MARK: - Segue
        
    @IBAction func closeUnwindSegue(unwindSegue: UIStoryboardSegue) {
        switch unwindSegue.identifier {
        case "closeSettingColorVC":
            if let SCVC = unwindSegue.source as? SettingColorViewController {
                imageScrollView.settingColorRGB = SCVC.settingColorRGB
                colorUp(RGB: imageScrollView.settingColorRGB)
            }
        default:
            fatalError("Error segue in EditorViewController")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "SettingColorVC":
            if let SCVC = segue.destination as? SettingColorViewController {
                SCVC.settingColorRGB = imageScrollView.settingColorRGB
            }
        default:
            fatalError("Error segue in EditorViewController")
        }
    }
    
    
    // MARK: - Image display
    
    
    var targetSize: CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: imageScrollView.bounds.width * scale, height: imageScrollView.bounds.height * scale)
    }
    
    func updateImage() {
        updateStaticImage()
    }
    
    func updateStaticImage() {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { image, _ in
            guard let image = image else { return }
            self.imageScrollView.set(image: image)
        })
    }
    
    
    // MARK: - view
    
    func colorUp(RGB: SettingColorRGB) {
        colorPickerButton.colorUpdata(CGColor(red: RGB.red , green: RGB.green, blue: RGB.blue, alpha: RGB.opacity))
        if let cell = toolseCollectionView.currentCell {
            cell.setColor(UIColor(red: RGB.red, green: RGB.green, blue: RGB.blue, alpha: RGB.opacity))
        }
    }
    
    func colorPickerButtonUP() {
        if let color = toolseCollectionView.currentCell.tool.color {
            colorPickerButton.colorUpdata(color.color.cgColor)
            imageScrollView.settingColorRGB = color
        }
    }
    
    func sliderUp() {
        if let widht = toolseCollectionView.currentCell.tool.widht {
            segmentedControl.slider.value = widht
            imageScrollView.brushWidth = CGFloat(widht)
        }
    }
    
    
    
    // MARK: - Сonstraint
    
    func setupImageScrollView() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
 
    
    
    // MARK: - Animation
    
    func animationWidht(_ widht: AnimationWidhtTool) {
        animationWidhtTool = widht
        switch widht {
        case .tools:
            animationWidhtDownloadButton(to: .downnload)
            downloadButton.animationSwicht(to: .downnload)
            segmentedControl.animationControler(to: .segment)
            backToCancelButtonView.animationButton(state: .back)
            animationScaleButton(to: .tools)
            toolseCollectionView.animation(to: .deselected)
        case .width:
            animationWidhtDownloadButton(to: .round)
            downloadButton.animationSwicht(to: .round)
            segmentedControl.animationControler(to: .slider)
            backToCancelButtonView.animationButton(state: .cancel)
            animationScaleButton(to: .width)
            toolseCollectionView.animation(to: .selected)
        }
    }
    
    private func animationWidhtDownloadButton(to state:DownnloadToRoundView.StateButton) {
        switch state {
        case .round:
            widhtButtonConstraint.constant = 76
        case .downnload:
            UIView.animate(withDuration: 0.5, delay: 0) {
                self.widhtButtonConstraint.constant = 33
                self.view.layoutIfNeeded()
            }
        }
        self.view.layoutIfNeeded()
    }
    
    private func animationScaleButton(to state:AnimationWidhtTool) {
        switch state {
        case .width:
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.colorPickerButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                self.addButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }) { (true) in
                self.addButton.isHidden = true
                self.colorPickerButton.isHidden = true
            }
        case .tools:
            self.addButton.isHidden = false
            self.colorPickerButton.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0) {
                self.colorPickerButton.transform = .identity
                self.addButton.transform = .identity
            }
        }
    }
}




// MARK: - PHPhotoLibraryChangeObserver

extension EditorViewController: PHPhotoLibraryChangeObserver {
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        // The call might come on any background queue. Re-dispatch to the main queue to handle it.
        DispatchQueue.main.sync {
            // Check if there are changes to the displayed asset.
            guard let details = changeInstance.changeDetails(for: asset) else { return }
            
            // Get the updated asset.
            asset = details.objectAfterChanges
            
            // If the asset's content changes, update the image and stop any video playback.
            if details.assetContentChanged {
                updateImage()
                
            }
        }
    }
}



// MARK: - Controllers


extension EditorViewController: WidthSliderDelegate {
    
    func getValue() {
        imageScrollView.brushWidth = CGFloat(segmentedControl.slider.value)
        toolseCollectionView.currentCell.setWidth(CGFloat(segmentedControl.slider.value))
    }
}

extension EditorViewController: ToolsCollectionViewDelegate {
    
    func cellTap() {
        sliderUp()
        colorPickerButtonUP()
    }
    
    func cellWidht() {
        animationWidht(.width)
    }
    
}

extension EditorViewController: ButtonDelegate {
    
    func tap() {
        switch animationWidhtTool {
        case .width:
            animationWidht(.tools)
        case .tools:
            dismiss(animated: true)
        }
    }
    
    
}
