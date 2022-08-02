//
//  ImageLoader.swift
//  Unsplash
//
//  Created by rae on 2022/05/25.
//

import Foundation

class ImageLoader {
    static let shared = ImageLoader()
    
    private let imageCacheManager = ImageCacheManager.shared
    private let imageQueue = OperationQueue()
    
    private init() {
        self.imageQueue.maxConcurrentOperationCount = 1
    }
    
    func load(_ urlString: String, completion: @escaping (Data) -> Void) {
        let key = urlString as NSString
        
        if let cachedData = self.imageCacheManager.load(key) {
            completion(cachedData)
            return
        }
        
        let imageDownloadOperation = ImageDownloadOperation(urlString: urlString) { [weak self] data in
            self?.imageCacheManager.save(key, data)
            completion(data)
        }

        self.imageQueue.addOperation(imageDownloadOperation)
    }
}
