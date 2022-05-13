//
//  ImageClient.swift
//  Unsplash
//
//  Created by rae on 2022/05/13.
//

import UIKit

protocol ImageClientable {
    func downloadImage<Request: DataRequestable>(request: Request, completion: @escaping (UIImage?, Error?) -> Void)
    func setImage(from url: String, placeholder: UIImage?, completion: @escaping (UIImage?) -> Void)
}

class ImageClient {
    
    static let shared = ImageClient(responseQueue: DispatchQueue.main, session: URLSession.shared)
    
    private(set) var cachedImageForURL: [String: UIImage]
    private(set) var cachedTaskForImageView: [UIImageView: NetworkService]
    
    let responseQueue: DispatchQueue?
    let session: URLSession
    
    init(responseQueue: DispatchQueue?, session: URLSession) {
        self.cachedImageForURL = [:]
        self.cachedTaskForImageView = [:]
        
        self.responseQueue = responseQueue
        self.session = session
    }
    
    private func dispathImage(
        image: UIImage? = nil,
        error: Error? = nil,
        completion: @escaping (UIImage?, Error?
        ) -> Void) {
        
        guard let responseQueue = responseQueue else {
            return completion(image, error)
        }

        responseQueue.async {
            completion(image, error)
        }
    }
}

extension ImageClient: ImageClientable {
    func downloadImage<Request: DataRequestable>(request: Request, completion: @escaping (UIImage?, Error?) -> Void) {
        
        let service: Networkable = NetworkService()
        
        service.request(request) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                guard let image: UIImage = response as? UIImage else {
                    return
                }
                
                self.dispathImage(image: image, error: nil, completion: completion)
            case .failure(let error):
                self.dispathImage(image: nil, error: error, completion: completion)
            }
        }
    }
    
    func setImage(from url: String, placeholder: UIImage?, completion: @escaping (UIImage?) -> Void) {
        let request = ImageRequest(url: url)
        if let cacheImage = cachedImageForURL[url] {
            completion(cacheImage)
        } else {
            downloadImage(request: request) { [weak self] image, error in
                guard let self = self else { return }
                
                guard let image = image else {
                    print(error?.localizedDescription ?? "SET_IMAGE_ERROR")
                    return
                }
                
                self.cachedImageForURL[url] = image
                completion(self.cachedImageForURL[url])
            }
        }
    }
}
