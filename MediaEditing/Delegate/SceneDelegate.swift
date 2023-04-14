//
//  SceneDelegate.swift
//  MediaEditing
//
//  Created by Сергей Насыбуллин on 10.10.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let accses = UserDefaults.standard.bool(forKey: "accses")
        
        if !DataModelController.accsesPhoto() {
            window?.rootViewController = DuckViewController()
            window?.makeKeyAndVisible()
        }
        
    }

}

