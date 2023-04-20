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
    
    var animationWidhtTool: AnimationWidhtTool = .tools
    
    var asset: PHAsset!
    
    @IBOutlet weak var imageDrawView: CanvasView!
    @IBOutlet weak var toolBarView: UIView!
    @IBOutlet weak var zoomButton: UIButton!
    @IBOutlet weak var segmentedControl: SegmentSliderView!
    @IBOutlet weak var downloadButton: DownnloadToRoundView!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var clearAllButton: UIButton!
    @IBOutlet weak var colorPickerButton: ColorPickerButton!
    @IBOutlet weak var toolseCollectionView: ToolsCollectionView!
    @IBOutlet weak var backToCancelButtonView: BackToCancelButton!
    @IBOutlet weak var addButton: AddButton!
    @IBOutlet weak var widhtButtonConstraint: NSLayoutConstraint!
    
    var colorRoundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = .zero
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = CGColor(gray: 0, alpha: 1)
        view.isHidden = true
        return view
    }()
    
    @IBOutlet weak var blureView: BlurGradientView!
    
    
    var dataModelController: DataModelController = DataModelController()
    
    
    // MARK: - UIViewController / Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.shared().register(self)
        
        setupImageDrawView()
        
        toolseCollectionView.tools = DataModel.tools
        
        imageDrawView.delegate = self
        toolseCollectionView.toolsCollectionViewDelegate = self
        segmentedControl.slider.delegate = self
        backToCancelButtonView.delegate = self
        downloadButton.delegate = self
        addButton.delegate = self
        
        // Перенести !!!!!!!!!!!!!
        segmentedControl.slider.maximumValue = 24
        segmentedControl.slider.minimumValue = 4
        
        
        colorUp(dataModelController.currentTool.color)
        
        setupView()
    }
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateImage()
        showZoomOutAnimation(false)
    }
    
    
    
    // MARK: - Action
    
    
    // Navigation bar
    @IBAction func undo(_ sender: UIButton) {
        imageDrawView.undoManager?.undo()
        undoButton.isEnabled = (imageDrawView.undoManager?.canUndo ?? true)
        clearAllButton.isEnabled = (imageDrawView.undoManager?.canUndo ?? true)
    }
    
    @IBAction func clearAll(_ sender: UIButton) {
        imageDrawView.drawing = PKDrawing()
        undoButton.isEnabled = false
        clearAllButton.isEnabled = false
    }
    
    @IBAction func zooming(_ sender: UIButton) {
        imageDrawView.setZoomScale(imageDrawView.minimumZoomScale, animated: true)
    }
    
    @IBAction func addPatch(_ sender: UIButton) {}
    
    
    
    // MARK: - Segue
        
    @IBAction func closeUnwindSegue(unwindSegue: UIStoryboardSegue) {
        switch unwindSegue.identifier {
        case "closeSettingColorVC":
            if let SCVC = unwindSegue.source as? SettingColorViewController {
                toolseCollectionView.currentTool.color = SCVC.color
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
                if toolseCollectionView.currentTool.color != nil {
                    SCVC.color = toolseCollectionView.currentTool.color
                } else {
                    SCVC.color = UIColor(white: 1, alpha: 1)
                }
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
        
        imageDrawView.set(DataModel.tools[0])
    }
    
    
    
    // MARK:  Image downlaound
    
    func imageDownlound() {
        UIGraphicsBeginImageContextWithOptions(imageDrawView.imageView.bounds.size, false, UIScreen.main.scale / 2)
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
    
    
    
    // MARK: - setupView
    
    
    func setupView() {
        self.view.addSubview(colorRoundView)
        undoButton.isEnabled = false
        clearAllButton.isEnabled = false
        
        let image = UIImage(named: "zoomOut")
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 23, height: 23), false, UIScreen.main.scale)
        image?.draw(in: CGRect(origin: .zero, size: CGSize(width: 23, height: 23)))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        zoomButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 4)
        zoomButton.setImage(newImage, for: .normal)
    }
    
    
    // MARK: - viewUp
    
    
    func colorUp(_ color: UIColor) {
        colorPickerButton.color = color
        if let cell = toolseCollectionView.currentCell {
            cell.setColor(color)
            imageDrawView.set(toolseCollectionView.currentTool)
        }
    }
    
    func colorPickerButtonUP() {
        colorPickerButton.color = toolseCollectionView.currentTool.color
    }
    
    func sliderWidthUp() {
        if let widht = toolseCollectionView.currentTool.widht {
            segmentedControl.slider.value = widht
        }
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
            UIView.animate(withDuration: 0.4, delay: 0) {
                self.widhtButtonConstraint.constant = 33
                self.view.layoutIfNeeded()
            }
        }
        self.view.layoutIfNeeded()
    }
    
    private func animationScaleButton(to state:AnimationWidhtTool) {
        switch state {
        case .width:
            UIView.animate(withDuration: 0.4, delay: 0, animations: {
                self.colorPickerButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                self.colorPickerButton.alpha = 0
                self.addButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                self.addButton.alpha = 0
            }) { (true) in
                self.addButton.isHidden = true
                self.colorPickerButton.isHidden = true
            }
        case .tools:
            self.addButton.isHidden = false
            self.colorPickerButton.isHidden = false
            UIView.animate(withDuration: 0.4, delay: 0) {
                self.colorPickerButton.transform = .identity
                self.colorPickerButton.alpha = 1
                self.addButton.transform = .identity
                self.addButton.alpha = 1
            }
        }
    }
    
    
    func colorRoundViewAnimation(width: CGFloat) {
        colorRoundView.frame = CGRect(origin: CGPoint(x: (self.view.bounds.width - width) / 2 , y: (self.view.bounds.height - width) / 2),
                                      size: CGSize(width: width, height: width))
        colorRoundView.layer.cornerRadius = colorRoundView.bounds.height / 2
        colorRoundView.layer.shadowPath = UIBezierPath(ovalIn: colorRoundView.bounds).cgPath
    }
    
    
    var zoomAnimator = UIViewPropertyAnimator()
    
    func showZoomOutAnimation(_ isShow: Bool) {
        guard !zoomAnimator.isRunning else { return }
        
        zoomAnimator = UIViewPropertyAnimator(duration: 0.15, curve: .easeIn)
        
        switch isShow {
        case true:
            // Show "zoom"
            self.zoomButton.isHidden = false
            zoomAnimator.addAnimations {
                self.zoomButton.transform = .identity
            }
        case false:
            // Hide "zoom"
            zoomAnimator.addAnimations {
                self.zoomButton.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
            }
            zoomAnimator.addCompletion { pozition in
                if pozition == .end {
                    self.zoomButton.isHidden = true
                }
            }
        }
        zoomAnimator.startAnimation()
    }
    
    
    // MARK: - UIFeedbackGenerator
    
    
    func haptic() {
        let generator = UIImpactFeedbackGenerator(style:.light)
        generator.impactOccurred()
    }
}







// MARK: - Controllers Action


extension EditorViewController: WidthSliderDelegate {
    
    func getValue() {
        toolseCollectionView.currentCell.setWidth(CGFloat(segmentedControl.slider.value))
        imageDrawView.set(toolseCollectionView.currentCell.tool)
    }
}


extension EditorViewController: ToolsCollectionViewDelegate {
    
    func startTouch() {}
    
    func beginTouch(widht: CGFloat) {
        colorRoundView.isHidden = false
        toolseCollectionView.currentCell.setWidth(CGFloat(widht))
        imageDrawView.set(toolseCollectionView.currentCell.tool)
        sliderWidthUp()
        colorRoundViewAnimation(width: widht)
    }
    
    func endTouch() {
        colorRoundView.isHidden = true
    }
    
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
                // Получения ширины если она есть.
                sliderWidthUp()
                // Устноовить ширину слайдера.
                // Анимация. Передйает все предустоновки до.
                animationWidht(.width)
                // Устновока кнопки наконечника
                downloadButton.imageName = toolseCollectionView.currentCell.tool.currentTip.rawValue + "Tip"
                downloadButton.label.text = toolseCollectionView.currentCell.tool.currentTip.rawValue
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
            imageDrawView.setZoomScale(imageDrawView.minimumZoomScale, animated: true)
            dismiss(animated: true)
        }
    }
}


/// Кнопка загрузки / выбор наконечника
extension EditorViewController: ButtonTwo {
    
    func downnload() {
        imageDownlound()
    }
    
    func round() {
        var actions:[UIAction] = []
        for i in self.toolseCollectionView.currentTool.toolTip.reversed() {
            let action = UIAction(title: NSLocalizedString(i.rawValue , comment: ""),
                     image: UIImage(named: i.rawValue  + "Tip")) { action in
                self.tipPen(i)
            }
            actions.append(action)
        }
        downloadButton.button.menu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: actions)
        downloadButton.button.showsMenuAsPrimaryAction = true
    }
    
    func tipPen(_ tip: ToolTip.Tip) {
        downloadButton.imageName = tip.rawValue + "Tip"
        downloadButton.label.text = tip.rawValue
        downloadButton.button.showsMenuAsPrimaryAction = false
        downloadButton.button.menu = nil
        toolseCollectionView.currentCell.tool.currentTip = tip
        print(tip.rawValue)
    }
}

extension EditorViewController: AddButtonDelegate {
    func getFigure(_ figure: DrawingFigure.Figure) {
        print(figure.rawValue)
    }
}



// MARK: - PKCanvasViewDelegate


extension EditorViewController: PKCanvasViewDelegate {
    
    // Responding to drawing-related changes
    
    func canvasViewDidFinishRendering(_ canvasView: PKCanvasView) {
//        print("canvasViewDidFinishRendering")
//        undoButton.isEnabled = true
//        clearAllButton.isEnabled = true
    }
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
//        print("canvasViewDrawingDidChange")
        undoButton.isEnabled = (imageDrawView.undoManager?.canUndo ?? false)
        clearAllButton.isEnabled = (imageDrawView.undoManager?.canUndo ?? false)
    }
    
    
    // Responding to new event sequences
    
    func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
//        print("canvasViewDidBeginUsingTool")
    }
    
    func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
//        print("canvasViewDidEndUsingTool")
    }
    
}

extension EditorViewController: UIScrollViewDelegate {
        
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale <= scrollView.minimumZoomScale {
            if !zoomButton.isHidden {
                showZoomOutAnimation(false)
            }
        } else {
            if zoomButton.isHidden {
                showZoomOutAnimation(true)
            }
        }
    }
}



//  scrolling and dragging

/*
 func scrollViewDidScroll(_ scrollView: UIScrollView) {}
 
 func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
 print("scrollViewWillBeginDecelerating")
 }
 func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
 print("scrollViewDidEndDecelerating")
 }
 func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
 print("scrollViewWillEndDragging")
 }
 func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
 print("scrollViewWillBeginDragging")
 }
 func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
 print("scrollViewDidEndDragging")
 }
 */

// zooming

/*
 func scrollViewWillBeginZooming(_: UIScrollView, with: UIView?) {}
 */





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



