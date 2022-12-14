//
//  ImageSaveManager.swift
//  Unsplash
//
//  Created by rae on 2022/12/14.
//

import UIKit

protocol ImageSaveManagerDelegate: AnyObject {
    func imageSaveFailure()
    func imageSaveSuccess()
}

final class ImageSaveManager: NSObject {
    weak var delegate: ImageSaveManagerDelegate?
    
    func writeToPhotoAlbum(with imageURL: String) {
        guard let url = URL(string: imageURL) else {
            return
        }
        ImageCacheManager().getImage(imageURL: url) { [weak self] data in
            guard let image = UIImage(data: data) else {
                return
            }
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self?.saveCompleted(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let _ = error {
            delegate?.imageSaveFailure()
        } else {
            delegate?.imageSaveSuccess()
        }
    }
}
