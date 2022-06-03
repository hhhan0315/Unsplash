//
//  ImageDownloadOperation.swift
//  Unsplash
//
//  Created by rae on 2022/05/24.
//

import Foundation

class ImageDownloadOperation: Operation {
    
    private var task: URLSessionDataTask?
    private let url: URL
    private let completion: ((Data) -> Void)
    
    init(url: URL, completion: @escaping ((Data) -> Void)) {
        self.url = url
        self.completion = completion
        super.init()
    }
    
    override func main() {
        super.main()
        
        if isCancelled { return }
        
        self.task = URLSession.shared.dataTask(with: self.url) { data, response, error in
            guard let data = data else { return }
            self.completion(data)
        }
        
        self.task?.resume()
    }
    
//    override func cancel() {
//        super.cancel()
//        
//        self.task?.cancel()
//    }
}
