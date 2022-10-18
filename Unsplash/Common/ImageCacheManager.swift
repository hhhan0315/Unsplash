//
//  ImageCacheManager.swift
//  Unsplash
//
//  Created by rae on 2022/05/21.
//

import Foundation

//final class ImageCacheManager {
//    static let shared = ImageCacheManager()
//    private init() { }
//    
//    private var memory = NSCache<NSString, NSData>()
//    
//    func save(with string: String, data: Data) {
//        let key = string as NSString
//        self.memory.setObject(NSData(data: data), forKey: key)
//    }
//    
//    func load(with string: String) -> Data? {
//        let key = string as NSString
//        if let data = self.memory.object(forKey: key) {
//            return Data(referencing: data)
//        }
//        return nil
//    }
//}
