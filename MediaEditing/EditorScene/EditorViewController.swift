//
//  EditorViewController.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 11.01.2023.
//

import UIKit
import Photos
import PhotosUI


class EditorViewController: UIViewController {
    
    var asset: PHAsset!
    
    @IBOutlet weak var imageScrollView: ImageScrollView!
    
    @IBOutlet weak var zoomView: UIStackView!
    
    @IBOutlet weak var navigationBarView: NavigationBar!
    @IBOutlet weak var TabBarView: ToolBar!
    
    
    // MARK: - UIViewController / Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PHPhotoLibrary.shared().register(self)
        setupImageScrollView()
    }
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateImage()
    }
    
    
    
    // MARK: - Action
    
    
    // MARK:  Navigation bar
    
    @IBAction func undo(_ sender: UIButton) { }
    
    @IBAction func clearAll(_ sender: UIButton) { }
    
    
    // MARK:  Tab bar
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func download(_ sender: UIButton) {}
    
    
    // MARK:  Tool bar
    
    @IBAction func pen(_ sender: UIButton) {}
    
    
    // MARK: - Segue
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { }
    
    
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
    
    
    
    // MARK: - Сonstraint
    
    func setupImageScrollView() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
}


// MARK: PHPhotoLibraryChangeObserver
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



