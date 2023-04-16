//
//  EditorViewController.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 11.01.2023.
//

import UIKit
import Photos
import PhotosUI
import PencilKit
import Lottie


class EditorViewController: UIViewController {
    
    enum AnimationWidhtTool {
        case tools
        case width
    }
    
    var asset: PHAsset!
    
    
    @IBOutlet weak var imageDrawView: CanvasView!
    @IBOutlet weak var toolBarView: UIView!
    @IBOutlet weak var zoomView: UIStackView!
    @IBOutlet weak var segmentedControl: SegmentSliderView!
    @IBOutlet weak var downloadButton: DownnloadToRoundView!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var clearAllButton: UIButton!
    @IBOutlet weak var colorPickerButton: ColorPickerButton!
    @IBOutlet weak var toolseCollectionView: ToolsCollectionView!
    @IBOutlet weak var backToCancelButtonView: BackToCancelButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var widhtButtonConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var blureView: BlurGradientView!
    
    var animationWidhtTool: AnimationWidhtTool = .tools
    
    
    // Набор инструментов
    private let tools = [
        Tool(toolName: .pen, color: .blue, widht: 12),
        Tool(toolName: .brush, color: .red, widht: 14),
        Tool(toolName: .brush, color: .black, widht: 8),
        Tool(toolName: .pencil, color: .gray, widht: 28),
        Tool(toolName: .lasso),
        Tool(toolName: .eraser)
    ]
    
    private let toolsPK: [PKTool] = [
        PKInkingTool(.pen, color: .blue, width: 12)
        
    ]
    
    // MARK: - UIViewController / Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PHPhotoLibrary.shared().register(self)
        
        setupImageDrawView()
        
        toolseCollectionView.tools = tools
        toolseCollectionView.toolsCollectionViewDelegate = self
        
        imageDrawView.set(tools[0])
        
        segmentedControl.slider.delegate = self
        backToCancelButtonView.delegate = self
        downloadButton.delegate = self
        
        segmentedControl.slider.maximumValue = 24
        segmentedControl.slider.minimumValue = 4
        
        zoomView.isHidden = true
        
        colorUp(tools[0].color)
        
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
        imageDrawView.undoManager?.undo()
    }
    
    @IBAction func clearAll(_ sender: UIButton) {
        imageDrawView.drawing = PKDrawing()
    }
    
    
    
    // MARK: - Segue
        
    @IBAction func closeUnwindSegue(unwindSegue: UIStoryboardSegue) {
        switch unwindSegue.identifier {
        case "closeSettingColorVC":
            if let SCVC = unwindSegue.source as? SettingColorViewController {
                toolseCollectionView.currentCell.tool.color = SCVC.color
                colorUp(SCVC.color)
            }
        default:
            fatalError("Error segue in EditorViewController")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "SettingColorVC":
            if let SCVC = segue.destination as? SettingColorViewController {
                SCVC.color = toolseCollectionView.currentCell.tool.color
            }
        default:
            fatalError("Error segue in EditorViewController")
        }
    }
    
    
    // MARK: - Image display
    
    
    var targetSize: CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: imageDrawView.bounds.width * scale, height: imageDrawView.bounds.height * scale)
    }
    
    func updateImage() {
        updateStaticImage()
    }
    
    func updateStaticImage() {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        
        PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options, resultHandler: { image, _ in
            guard let image = image else { return }
            self.imageDrawView.image = image
        })
    }
    
    
    // MARK:  Image downlaound
    
    func imageDownlound() {
        
        // imageDrawView.imageView.bounds.size
        UIGraphicsBeginImageContextWithOptions(imageDrawView.imageView.bounds.size, false, UIScreen.main.scale / 2)
//        imageDrawView.content .drawHierarchy(in: imageDrawView.imageView.bounds, afterScreenUpdates: false)
        
        let imageDraws = imageDrawView.drawing.image(from: imageDrawView.imageView.bounds, scale: UIScreen.main.scale / 2)
        
        // Merge tempImageView into mainImageView
        imageDrawView.imageView.image?.draw(in: imageDrawView.imageView.bounds, blendMode: .normal, alpha: 1)
        imageDraws.draw(in: imageDrawView.imageView.bounds, blendMode: .normal, alpha: 1)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image = image {
            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }
        }
    }
    
    
    
    // MARK: - view
    
    func colorUp(_ color: UIColor) {
        colorPickerButton.colorUpdata(color.cgColor)
        if let cell = toolseCollectionView.currentCell {
            cell.setColor(color)
            imageDrawView.set(toolseCollectionView.currentCell.tool)
        }
    }
    
    func colorPickerButtonUP() {
        if let color = toolseCollectionView.currentCell.tool.color {
            colorPickerButton.colorUpdata(color.cgColor)
        }
    }
    
    func sliderWidthUp() {
        if let widht = toolseCollectionView.currentCell.tool.widht {
            segmentedControl.slider.value = widht
        }
    }
    
    
    static func filteredImage(cgImage: CGImage, size:CGSize) -> UIImage? {
        if let matrixFilter = CIFilter(name: "CIColorMatrix") {
            matrixFilter.setDefaults()
            matrixFilter.setValue(CIImage(cgImage: cgImage), forKey: kCIInputImageKey)
            let rgbVector = CIVector(x: 0, y: 0, z: 0, w: 0)
            let aVector = CIVector(x: 1, y: 1, z: 1, w: 0)
            matrixFilter.setValue(rgbVector, forKey: "inputRVector")
            matrixFilter.setValue(rgbVector, forKey: "inputGVector")
            matrixFilter.setValue(rgbVector, forKey: "inputBVector")
            matrixFilter.setValue(aVector, forKey: "inputAVector")
            matrixFilter.setValue(CIVector(x: 1, y: 1, z: 1, w: 0), forKey: "inputBiasVector")
            
            if let matrixOutput = matrixFilter.outputImage, let cgImage = CIContext().createCGImage(matrixOutput, from: matrixOutput.extent) {
                return UIImage(cgImage: cgImage).resizableImage(withCapInsets: UIEdgeInsets(top: size.height, left: 0, bottom: 0, right: 0))
            }
        }
        return nil
    }
    
    
    
    
    // MARK: - Сonstraint
    
    func setupImageDrawView() {
        imageDrawView.translatesAutoresizingMaskIntoConstraints = false
        imageDrawView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageDrawView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageDrawView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageDrawView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
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
            animationCollection()
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
    
    func animationCollection() {
        
        let animation = CAKeyframeAnimation()

        let pathArray = [[NSValue(cgPoint: CGPoint(x: 20.0, y: 10.0))],
                         [NSValue(cgPoint: CGPoint(x: 100.0, y: 100.0))],
                         [NSValue(cgPoint: CGPoint(x: 10.0, y: 100.0))],
                         [NSValue(cgPoint: CGPoint(x: 10.0, y: 10.0))]]
        animation.keyPath = "position"
        animation.values = pathArray
        animation.duration = 2.0
//        self.toolseCollectionView.layer.add(animation, forKey: "position")
        
        self.colorPickerButton.layer.add(animation, forKey: "position")
        
    }
    
}







// MARK: - Controllers


extension EditorViewController: WidthSliderDelegate {
    
    func getValue() {
        toolseCollectionView.currentCell.setWidth(CGFloat(segmentedControl.slider.value))
        imageDrawView.set(toolseCollectionView.currentCell.tool)
    }
}


extension EditorViewController: ToolsCollectionViewDelegate {
    
    func cellTap() {
        if animationWidhtTool == .tools {
            sliderWidthUp()
            colorPickerButtonUP()
            imageDrawView.set(toolseCollectionView.currentCell.tool)
        }
    }
    
    func cellWidht() {
        if animationWidhtTool == .tools {
            if let _ = toolseCollectionView.currentCell.tool.widht {
                animationWidht(.width)
            }
        }
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

extension EditorViewController: ButtonTwo {
    
    func downnload() {
        print("downnload")
        imageDownlound()
    }
    
    func round() {
        print("round")
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
