//
//  ImageRequest.swift
//  Unsplash
//
//  Created by rae on 2022/05/13.
//

import UIKit

struct ImageRequest: DataRequestable {
    
    let url: String
    
    var method: HTTPMethod {
        .get
    }
    
    func decode(_ data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw NSError(domain: ErrorResponse.invalidResponse.rawValue, code: 13)
        }
        
        return image
    }
}
