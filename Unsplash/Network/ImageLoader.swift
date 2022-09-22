//
//  ImageLoader.swift
//  Unsplash
//
//  Created by rae on 2022/05/25.
//

import Foundation

final class ImageLoader {
    func load(with string: String, completion: @escaping (Data) -> Void) {
        guard let url = URL(string: string) else {
            return
        }
        
        if let cachedData = ImageCacheManager.shared.load(with: string) {
            completion(cachedData)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }
            
            ImageCacheManager.shared.save(with: string, data: data)
            completion(data)
        }.resume()
    }
}
