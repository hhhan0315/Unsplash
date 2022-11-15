//
//  UIImageView+Extension.swift
//  Unsplash
//
//  Created by rae on 2022/09/07.
//

import UIKit

extension UIImageView {
    func downloadImage(with photo: Photo?) {
        guard let urlString = photo?.urls.regular else {
            return
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        ImageCacheManager().getImage(imageURL: url) { data in
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
    }
    
    func downloadImage(with topic: Topic?) {
        guard let urlString = topic?.coverPhoto.urls.regular else {
            return
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        ImageCacheManager().getImage(imageURL: url) { data in
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
    }
}
