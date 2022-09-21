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
}
