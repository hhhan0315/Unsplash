//
//  ImageCacheManager.swift
//  Unsplash
//
//  Created by rae on 2022/05/21.
//

import Foundation

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    
    private var memory = NSCache<NSString, NSData>()
    
    private init() { }
    
    func save(_ key: NSString, _ data: Data) {
        self.memory.setObject(NSData(data: data), forKey: key)
    }
    
    func load(_ key: NSString) -> Data? {
        if let data = self.memory.object(forKey: key) {
            return Data(referencing: data)
        }
        return nil
    }
}
