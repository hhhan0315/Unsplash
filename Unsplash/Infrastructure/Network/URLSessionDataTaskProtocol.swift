//
//  URLSessionDataTaskProtocol.swift
//  Unsplash
//
//  Created by rae on 2022/09/22.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
