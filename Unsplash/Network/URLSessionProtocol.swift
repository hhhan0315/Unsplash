//
//  URLSessionProtocol.swift
//  Unsplash
//
//  Created by rae on 2022/09/22.
//

import Foundation

typealias DataTaskCompletionHandler = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol {
    func dataTask(with urlReqeust: URLRequest, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func dataTask(with urlReqeust: URLRequest, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTaskProtocol {
        return dataTask(with: urlReqeust, completionHandler: completionHandler) as URLSessionDataTask
    }
}
