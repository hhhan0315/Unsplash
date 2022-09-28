//
//  UIViewController+Extension.swift
//  Unsplash
//
//  Created by rae on 2022/09/21.
//

import UIKit

extension UIViewController {
    func showAlert(title: String = Alert.Title.error,
                   message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alert.ActionTitle.ok, style: .default))
        present(alert, animated: true)
    }
    
    func showPhotoSettingAlert() {
        let alert = UIAlertController(title: "Photo Library Access Denied", message: "Allow Photos access in Settings to save photos to your Photo Library", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }))
        present(alert, animated: true)
    }
}
