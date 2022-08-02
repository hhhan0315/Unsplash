//
//  ImageSaver.swift
//  Unsplash
//
//  Created by rae on 2022/08/02.
//

import UIKit

protocol ImageSaverDelegate: AnyObject {
    func saveFailure()
    func saveSuccess()
}

class ImageSaver: NSObject {
    weak var delegate: ImageSaverDelegate?
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let _ = error {
            delegate?.saveFailure()
        } else {
            delegate?.saveSuccess()
        }
    }
}
