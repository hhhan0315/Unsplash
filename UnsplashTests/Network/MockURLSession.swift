//
//  MockURLSession.swift
//  UnsplashTests
//
//  Created by rae on 2022/09/22.
//

import Foundation
@testable import Unsplash

final class MockURLSession: URLSessionProtocol {
    
    typealias Response = (data: Data?, urlResponse: URLResponse?, error: Error?)
    
    private let response: Response
    
    init(response: Response) {
        self.response = response
    }
    
    func dataTask(with urlRequest: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return MockURLSessionDataTask {
            completionHandler(self.response.data, self.response.urlResponse, self.response.error)
        }
    }
    
    static func make(url: URL, data: Data?, statusCode: Int) -> MockURLSession {
        let mockURLSession: MockURLSession = {
            let urlResponse = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)
            let mockResponse: MockURLSession.Response = (data: data, urlResponse: urlResponse, error: nil)
            let mockUrlSession = MockURLSession(response: mockResponse)
            return mockUrlSession
        }()
        return mockURLSession
    }
}
