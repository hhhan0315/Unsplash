//
//  URLSessionProtocol.swift
//  Unsplash
//
//  Created by rae on 2022/09/22.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with urlReqeust: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func dataTask(with urlReqeust: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: urlReqeust, completionHandler: completionHandler) as URLSessionDataTask
    }
}
