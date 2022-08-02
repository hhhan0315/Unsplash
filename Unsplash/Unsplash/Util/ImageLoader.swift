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
    
    func load(_ urlString: String, completion: @escaping (Data) -> Void) {
        let key = urlString as NSString
                
        guard let url = URL(string: urlString) else {
            return
        }
        
        if let cachedData = self.imageCacheManager.load(key) {
            completion(cachedData)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }
            
            self.imageCacheManager.save(key, data)
            completion(data)
        }.resume()
    }
}
