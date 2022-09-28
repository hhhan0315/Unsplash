//
//  ImageFileManager.swift
//  Unsplash
//
//  Created by rae on 2022/09/28.
//

import UIKit

final class ImageFileManager {
    init() {
        createDirectory()
    }
    
    private let fileManager = FileManager.default
    private lazy var directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("UnsplashRae")
    
    private func createDirectory() {
        if !fileManager.fileExists(atPath: directoryURL.path) {
            do {
                try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchImageURLString(id: String) -> String {
        return directoryURL.appendingPathComponent(id).appendingPathExtension("png").path
    }
    
    func saveImage(id: String, data: Data, completion: (Result<Bool, Error>) -> Void) {
        guard let image = UIImage(data: data) else {
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return
        }
        
        let fileURL = directoryURL.appendingPathComponent(id).appendingPathExtension("png")
        
        do {
            try imageData.write(to: fileURL)
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
    
    func deleteImage(id: String, completion: (Result<Bool, Error>) -> Void) {
        do {
            try fileManager.removeItem(atPath: fetchImageURLString(id: id))
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetchImage(id: String) -> UIImage? {
        return UIImage(contentsOfFile: fetchImageURLString(id: id))
    }
    
    func existImageInFile(id: String, completion: (Bool) -> Void) {
        let path = fetchImageURLString(id: id)
        fileManager.fileExists(atPath: path) ? completion(true) : completion(false)
    }
}
