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



enum AnimationWidhtTool {
    case tools
    case width
}




class EditorViewController: UIViewController, ButtonDelegate {
    
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
    @IBOutlet weak var toolseCollectionView: UICollectionView!
    
    @IBOutlet weak var backToCancelButtonView: BackToCancelButton!
    
    @IBOutlet weak var addButton: UIButton!
    
//    @IBOutlet weak var barStackView: UIStackView!
    
    var currentCell = ToolsDrawCell()
    
    var animationWidhtTool: AnimationWidhtTool = .tools
    
    @IBOutlet weak var widhtButtonConstraint: NSLayoutConstraint!
    
    // Набор инструментов
    private let tools = [
        Tool(toolImageName: "pen", color: SettingColorRGB(red: 0, green: 0, blue: 0, opacity: 1), widht: 14),
        Tool(toolImageName: "brush", color: SettingColorRGB(red: 0, green: 0, blue: 0, opacity: 1), widht: 14),
        Tool(toolImageName: "brush", color: SettingColorRGB(red: 0, green: 0, blue: 0, opacity: 1), widht: 14),
        Tool(toolImageName: "pencil", color: SettingColorRGB(red: 0, green: 0, blue: 0, opacity: 1), widht: 14),
        Tool(toolImageName: "lasso"),
        Tool(toolImageName: "eraser", widht: 14)
    ]
    
    
    // MARK: - UIViewController / Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PHPhotoLibrary.shared().register(self)

        toolseCollectionView.delegate = self
        toolseCollectionView.dataSource = self
        toolseCollectionView.backgroundColor = .clear
        
        setupImageScrollView()
        
        colorUp(RGB: imageScrollView.settingColorRGB)
        
        segmentedControl.slider.delegate = self
        backToCancelButtonView.delegate = self
        
        segmentedControl.slider.maximumValue = 24
        segmentedControl.slider.minimumValue = 4
        segmentedControl.slider.value = 14
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
    
    
    func tap() {
        switch animationWidhtTool {
        case .width:
            animationWidht(.tools)
        case .tools:
            dismiss(animated: true)
        }
    }
    
    
    
    @IBAction func download(_ sender: UIButton) {
        print("download")
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
        currentCell.setColor(UIColor(red: RGB.red, green: RGB.green, blue: RGB.blue, alpha: RGB.opacity))
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
            animationTools(to: .tools)
        case .width:
            animationWidhtDownloadButton(to: .round)
            downloadButton.animationSwicht(to: .round)
            segmentedControl.animationControler(to: .slider)
            backToCancelButtonView.animationButton(state: .cancel)
            animationScaleButton(to: .width)
            animationTools(to: .width)
        }
    }
    
    
    /*
     Для анимации решил скрывать все ячейки через уменьшение высоты карандашей с задержкой в зависимости от их позиции в коллекции одновременно с выдвижением нужного на позицию посередине (через изменение позиций ячеек). При этом также используется плавное увеличение толщины в зависимости от выставленного коэффициента.
     */
    func animationTools(to state: AnimationWidhtTool) {
        switch state {
        case.width:
            let cells = toolseCollectionView.visibleCells
            let tag = currentCell.tag
            animationCellCollection(tag: tag, cells: cells, delay: 0.05 * Double(cells.count))
            
            let centerX = toolseCollectionView.frame.width / 2 - currentCell.frame.origin.x - 20
            print(centerX)
            UIView.animate(withDuration: 0.05 * Double(cells.count + 1), delay: 0.1 * Double(cells.count + 1), animations: {
                
                var transform = CGAffineTransform(
                    translationX: centerX / 2,
                    y: 0)
                
                transform = transform.concatenating(CGAffineTransform(scaleX: 2, y: 1.5))
                
                self.currentCell.transform = transform
                
            }) { (true) in}
        case.tools:
            let cells = toolseCollectionView.visibleCells
            let tag = currentCell.tag
            animationCellCollection(tag: tag, cells: cells, delay: 0.05 * Double(cells.count))
            UIView.animate(withDuration: 0.05 * Double(cells.count), delay: 0, animations: {
                self.currentCell.transform = .identity
            }) { (true) in }
        }
    }
    
    func animationCellCollection(tag:Int, cells:[UICollectionViewCell], delay: Double) {
        if tag - 1 >= 0 {
            animationCellCollectionLeft(tag: tag - 1, cells: cells, delay: delay)
        }
        if tag + 1 < cells.count {
            animationCellCollectionRight(tag: tag + 1, cells: cells, delay: delay)
        }
    }
    
    
    func animationCellCollectionLeft(tag:Int, cells:[UICollectionViewCell], delay: Double) {
        cellAnimation(cell: cells[tag], delay: delay)
        if tag - 1 >= 0 {
            animationCellCollectionLeft(tag: tag - 1, cells: cells, delay: delay - 0.05)
        }
    }
    
    func animationCellCollectionRight(tag:Int, cells:[UICollectionViewCell], delay: Double) {
        cellAnimation(cell: cells[tag], delay: delay)
        if tag + 1 < cells.count {
            animationCellCollectionRight(tag: tag + 1, cells: cells, delay: delay - 0.05)
        }
    }
    
    
    func cellAnimation(cell: UICollectionViewCell, delay: Double) {
        switch animationWidhtTool {
        case .width:
            UIView.animate(withDuration: 0.25, delay: delay, animations: {
                cell.alpha = 0
                cell.frame.origin.y += cell.frame.origin.y
                
            }) { (true) in
                cell.isHidden = true
            }
        case .tools:
            cell.isHidden = false
            UIView.animate(withDuration: 0.25, delay: delay, animations: {
                cell.alpha = 1
                cell.frame.origin.y = 16
            }) { (true) in
//                cell.isHidden = false
            }

        }
        
    }
    
    
    
    
    func animationWidhtDownloadButton(to state:DownnloadToRoundView.StateButton) {
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
    
    func animationScaleButton(to state:AnimationWidhtTool) {
        switch state {
        case .width:
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.colorPickerButton.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                self.addButton.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            }) { (true) in
                self.addButton.isHidden = true
                self.colorPickerButton.isHidden = true
            }
        case .tools:
            self.addButton.isHidden = false
            self.colorPickerButton.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.colorPickerButton.transform = .identity
                self.addButton.transform = .identity
            }) { (true) in
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


extension EditorViewController: WidthSliderDelegate {
    
    func getValue() {
        imageScrollView.brushWidth = CGFloat(segmentedControl.slider.value)
        currentCell.setWidth(CGFloat(segmentedControl.slider.value))
    }
}



// MARK: - UICollectionViewDataSource


extension EditorViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tools.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "toolCell", for: indexPath) as! ToolsDrawCell
        
        cell.toolImage = UIImage(named: tools[indexPath.row].toolImageName)
        cell.tipImage = UIImage(named: tools[indexPath.row].toolImageName + "Tip")
        cell.tag = indexPath.row
        
        cell.frame.origin.y = 16
        
        if indexPath.row == 0 {
            currentCell = cell
            cell.setWidth(CGFloat(segmentedControl.slider.value))
            cell.frame.origin.y = 0
        }
        
        
        return cell
    }
}


extension EditorViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ToolsDrawCell
        if cell.tag == currentCell.tag {
            if animationWidhtTool == .tools {
                animationWidht(.width)
            }
        } else {
            currentCell.frame.origin.y = 16
            currentCell = cell
            currentCell.frame.origin.y = 0
        }
    }
}


extension EditorViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return centerCollectionCellLine()
    }
    
    private func centerCollectionCellLine() -> CGFloat {
        let freeLine = (toolseCollectionView.frame.width - CGFloat(tools.count) * 20) / (CGFloat(tools.count) + 1)
        return freeLine
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: centerCollectionCellLine(), bottom: 0, right: centerCollectionCellLine())
    }
    
}

