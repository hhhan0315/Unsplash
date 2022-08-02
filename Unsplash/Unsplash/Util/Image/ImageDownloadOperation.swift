//
//  ImageDownloadOperation.swift
//  Unsplash
//
//  Created by rae on 2022/05/24.
//

import Foundation

class ImageDownloadOperation: Operation {
    
    private var task: URLSessionDataTask?
    private let urlString: String
    private let completion: ((Data) -> Void)
    
    init(urlString: String, completion: @escaping ((Data) -> Void)) {
        self.urlString = urlString
        self.completion = completion
        super.init()
    }
    
    override func main() {
        super.main()
        
        if isCancelled {
            return
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }
            self.completion(data)
        }
        
        task?.resume()
    }
    
//    override func cancel() {
//        super.cancel()
//        
//        self.task?.cancel()
//    }
}
