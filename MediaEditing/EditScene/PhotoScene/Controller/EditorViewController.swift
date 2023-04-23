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
        
    // Canvas
    @IBOutlet weak var drawView: CanvasView!
    
    // (Navigation bar)
    @IBOutlet weak var zoomButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var clearAllButton: UIButton!
    
    // ToolBar
    @IBOutlet weak var colorPickerButton: ColorPickerButton!
    @IBOutlet weak var toolseCollectionView: ToolsCollectionView!
    @IBOutlet weak var addButton: AddButton!
    
    // Bar
    @IBOutlet weak var backToCancelButtonView: BackToCancelButton!
    @IBOutlet weak var segmentedControl: SegmentSliderView!
    @IBOutlet weak var downloadButton: DownnloadToRoundView!
    
    // Constraint
    @IBOutlet weak var widhtButtonConstraint: NSLayoutConstraint!
    
    /**
     Кружочек для обозначения выборо ширины.
     Есть неявная анимация ширины
     */
    var widhtRoundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = .zero
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = CGColor(gray: 0, alpha: 1)
        view.isHidden = true
        return view
    }()
    
    var asset: PHAsset!
    
    var dataModelController: DataModelController = DataModelController()
    
    var zoomAnimator = UIViewPropertyAnimator()
    
    
    
    // MARK: - UIViewController / Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PHPhotoLibrary.shared().register(self)
        
        setupImageDrawView()
        setupView()
        
        toolseCollectionView.tools = dataModelController.dataModel.tools
        
        
        drawView.delegate = self
        toolseCollectionView.toolsCellDelegate = self
        toolseCollectionView.toolsCellTouchDelegate = self
        segmentedControl.slider.delegate = self
        backToCancelButtonView.delegate = self
        downloadButton.delegate = self
        addButton.delegate = self
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
        drawView.undoManager?.undo()
        undoButton.isEnabled = (drawView.undoManager?.canUndo ?? true)
        clearAllButton.isEnabled = (drawView.undoManager?.canUndo ?? true)
    }
    
    @IBAction func clearAll(_ sender: UIButton) {
        drawView.drawing = PKDrawing()
        undoButton.isEnabled = false
        clearAllButton.isEnabled = false
    }
    
    @IBAction func zooming(_ sender: UIButton) {
        drawView.setZoomScale(drawView.minimumZoomScale, animated: true)
    }
    
    @IBAction func addPatch(_ sender: UIButton) {}
    
    
    
    // MARK: - Segue
        
    @IBAction func closeUnwindSegue(unwindSegue: UIStoryboardSegue) {
        switch unwindSegue.identifier {
        case "closeSettingColorVC":
            if let SCVC = unwindSegue.source as? SettingColorViewController {
                dataModelController = SCVC.dataModelController
            }
        default:
            fatalError("Error segue in EditorViewController")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "SettingColorVC":
            if let SCVC = segue.destination as? SettingColorViewController {
                SCVC.dataModelController = dataModelController
                SCVC.delegate = self
            }
        default:
            fatalError("Error segue in EditorViewController")
        }
    }
    
    
    
    // MARK: - Image display
    
    var targetSize: CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: drawView.bounds.width * scale, height: drawView.bounds.height * scale)
    }
    
    func updateImage() { updateStaticImage() }
    
    func updateStaticImage() {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        
        PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options, resultHandler: { image, _ in
            guard let image = image else { return }
            self.drawView.image = image
        })
    }
    
    
    
    // MARK:  Image downlaound
    
    func imageDownlound() {
        UIGraphicsBeginImageContextWithOptions(drawView.imageView.bounds.size, false, UIScreen.main.scale / 2)
        let imageDraws = drawView.drawing.image(from: drawView.imageView.bounds, scale: UIScreen.main.scale / 2)
        // Merge tempImageView into mainImageView
        drawView.imageView.image?.draw(in: drawView.imageView.bounds, blendMode: .normal, alpha: 1)
        imageDraws.draw(in: drawView.imageView.bounds, blendMode: .normal, alpha: 1)
        
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
        
        if let pen = dataModelController.currentTool as? Pen {
            colorPickerButton.color = pen.color
            drawView.setPen(pen)
        } else {
            colorPickerButton.color = nil
        }
        
        self.view.addSubview(widhtRoundView)
        undoButton.isEnabled = false
        clearAllButton.isEnabled = false
        
        if let image = UIImage(named: "zoomOut")?.resizeImage(size: CGSize(width: 23, height: 23)) {
            zoomButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 4)
            zoomButton.setImage(image, for: .normal)
        }
    }
    
    
    
    // MARK: - Updates
    
    func updateColor(_ newColor: UIColor) {
        if let pen = dataModelController.currentTool as? Pen {
            colorPickerButton.color = pen.color
        } else {
            colorPickerButton.color = nil
        }
        toolseCollectionView.currentCell.setColor(newColor)
    }
    
    
    
    
    
    // MARK: - Сonstraint
    
    func setupImageDrawView() {
        drawView.translatesAutoresizingMaskIntoConstraints = false
        drawView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        drawView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        drawView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        drawView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
 
    
    
    // MARK: - Animation
    
    func animationWidht(_ state: ToolsCollectionView.CollectionShows) {
        switch state {
        case .tools:
            toolseCollectionView.currentStateCollection = .tools
            addButton.animationShow(is: true)
            colorPickerButton.animationShow(is: true)
            downloadButton.animationSwicht(to: .downnload)
            animationWidhtDownloadButton(to: downloadButton.isButton)
            segmentedControl.animationControler(to: .segment)
            backToCancelButtonView.animationButton(state: .back)
        case .toolSelected:
            toolseCollectionView.currentStateCollection = .toolSelected
            addButton.animationShow(is: false)
            colorPickerButton.animationShow(is: false)
            downloadButton.animationSwicht(to: .round)
            animationWidhtDownloadButton(to: downloadButton.isButton)
            segmentedControl.animationControler(to: .slider)
            backToCancelButtonView.animationButton(state: .cancel)
        }
    }
    
    /// Обновляет ограничения для downloadButton. Для раскрыитя выбора наконечника (Tip)
    private func animationWidhtDownloadButton(to state: DownnloadToRoundView.IsButton) {
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
    
    // Перенести в отдельый класс 
    func colorRoundViewAnimation(width: CGFloat) {
        widhtRoundView.frame = CGRect(origin: CGPoint(x: (self.view.bounds.width - width) / 2 , y: (self.view.bounds.height - width) / 2),
                                      size: CGSize(width: width, height: width))
        widhtRoundView.layer.cornerRadius = widhtRoundView.bounds.height / 2
        widhtRoundView.layer.shadowPath = UIBezierPath(ovalIn: widhtRoundView.bounds).cgPath
    }
    
    // Перенести в отделый класс
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







// MARK: - Tool Changes

// ToolsCollectionView
extension EditorViewController: ToolsDrawCellTouchDelegate, ToolsCollectionViewDelegate {
    
    // Выбрали новый инструмент
    func selectedNewCell(_ cell: ToolsDrawCell) {
        // Устновоить новый инструмент
        dataModelController.setNewTool(index: cell.tag)
        
        if let pen = dataModelController.currentTool as? Pen {
            colorPickerButton.color = pen.color
        } else {
            colorPickerButton.color = nil
        }
    }
    
    // Анимация выдиления
    // На экране виден: slider, downloadButton.roundButton. Устоновить значения перед анимацией
    func openWidthTool(_ cell: ToolsDrawCell) {
        if let pen = dataModelController.currentTool as? Pen {
            segmentedControl.slider.setWidthRange(range: pen.validWidthRange, value: pen.width)
            downloadButton.typeRoundButton = pen.tipType
        } else if let eraser = dataModelController.currentTool as? Eraser {
            segmentedControl.slider.setWidthRange(range: eraser.validWidthRange, value: eraser.width)
            downloadButton.typeEraserButton = eraser.typeEraser
        }
        animationWidht(.toolSelected)
    }
    
    func beginTouch(_ deltaWidth: CGFloat) {
        if let pen = dataModelController.currentTool as? Pen {
            let newWdith = pen.width + ( deltaWidth / pen.validWidthRange.lowerBound)
            if pen.validWidthRange.contains(newWdith) {
                colorRoundViewAnimation(width: newWdith)
                widhtRoundView.isHidden = false
                dataModelController.setWidth(newWdith)
                toolseCollectionView.currentCell.setWidth(newWdith)
            }
        } else if let eraser = dataModelController.currentTool as? Eraser {
            let newWdith = eraser.width + ( deltaWidth / eraser.validWidthRange.lowerBound)
            if eraser.validWidthRange.contains(newWdith) {
                colorRoundViewAnimation(width: newWdith)
                widhtRoundView.isHidden = false
                dataModelController.setWidth(newWdith)
            }
        }
    }
    
    func endTouch() {
        widhtRoundView.isHidden = true
    }
    
}

// Segment Control
extension EditorViewController: WidthSliderDelegate {
    
    
    // Новая ширина
    func getValue(_ value: Float) {
        if dataModelController.currentTool is Pen {
            colorRoundViewAnimation(width: CGFloat(value))
            toolseCollectionView.currentCell.setWidth(CGFloat(value))
        }
        dataModelController.setWidth(CGFloat(value))
    }
    
    func beginTouchSlider(_ width: CGFloat) { widhtRoundView.isHidden = false }
    
    func endTouchSlider() { widhtRoundView.isHidden = true }
}


// Setting Color View Controller | Изменения цвета
extension EditorViewController: ColorObserver {
    // Изменения цвета
    func colorChanged(_ color: UIColor?) {
        colorPickerButton.color = color
        if let color = color {
            dataModelController.setColor(color)
            toolseCollectionView.currentCell.setColor(color)
        }
    }
}


/// Кнопка загрузки / выбор наконечника
extension EditorViewController: ButtonTwo {
    // Загрузка фото
    func downnload() { imageDownlound() }
    
    // Выбрали новый наконечник
    func newTip(_ newTip: Pen.TipType) {
        dataModelController.setPenTip(newTip)
    }
    
    // Выбрали новый ластик
    func newEraser(_ type: Eraser.TypeEraser) {
        dataModelController.setEraser(type)
        toolseCollectionView.currentCell.tool = dataModelController.currentTool
    }
}



// MARK:  Canves add


/// Кнопка добавить (addButton)
extension EditorViewController: AddButtonDelegate {
    
    func getFigure(_ figure: DrawingFigure.Figure) {
        // Обновить содержимое холста
        print("Добавленая фигура")
    }
}



// MARK: -  Clouse

extension EditorViewController: ButtonDelegate {
    
    func tap() {
        switch backToCancelButtonView.isState {
        case .cancel:
            // Кнопка закрыть
            drawView.setZoomScale(drawView.minimumZoomScale, animated: false)
            dismiss(animated: true)
        case .back:
            // Вернутся обратно
            animationWidht(.tools)
        }
    }
}



// MARK: - PKCanvasViewDelegate


extension EditorViewController: PKCanvasViewDelegate {
    
    // Responding to drawing-related changes
    
    func canvasViewDidFinishRendering(_ canvasView: PKCanvasView) {}
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        undoButton.isEnabled = (drawView.undoManager?.canUndo ?? false)
        clearAllButton.isEnabled = (drawView.undoManager?.canUndo ?? false)
    }
    
    
    // Responding to new event sequences
    
    func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
        if let pen = dataModelController.currentTool as? Pen {
            drawView.setPen(pen)
        } else if let eraser = dataModelController.currentTool as? Eraser {
            drawView.setEraser(eraser)
        } else if let lasso = dataModelController.currentTool as? Lasso {
            drawView.setLasso(lasso)
        }
    }
    
    func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {}
    
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
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        drawView.becomeFirstResponder()
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



