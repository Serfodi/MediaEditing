//
//  PhotosController.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 14.04.2023.
//

import UIKit
import Photos


class PhotosController {
 
    static func accsesPhoto() -> Bool {
        if #available(iOS 14, *) {
            let readWriteStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            switch readWriteStatus {
            case .authorized, .limited:
                UserDefaults.standard.set(true, forKey: "accses")
                return true
            case .notDetermined, .restricted, .denied:
                UserDefaults.standard.set(false, forKey: "accses")
                return false
            @unknown default:
                fatalError()
            }
        } else {
            UserDefaults.standard.set(true, forKey: "accses")
            return true
        }
    }
    
    
    
}
