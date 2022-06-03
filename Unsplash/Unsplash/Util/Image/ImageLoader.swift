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
    
    func load(_ url: URL, completion: @escaping (Data) -> Void) {
        let key = url as NSURL
        if let cachedData = self.imageCacheManager.load(key) {
            completion(cachedData)
            return
        }
        
        let imageDownloadOperation = ImageDownloadOperation(url: url) { [weak self] data in
            self?.imageCacheManager.save(key, data)
            completion(data)
        }

        self.imageQueue.addOperation(imageDownloadOperation)
    }
}
