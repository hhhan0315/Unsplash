//
//  MockURLSession.swift
//  UnsplashTests
//
//  Created by rae on 2022/09/22.
//

import Foundation
@testable import Unsplash

final class MockURLSession: URLSessionProtocol {
    let dummyData: Data
    let url = URL(string: "https://test.com")!
    
    var condition: NetworkError?
    
    init() {
        let path = Bundle.main.path(forResource: "content", ofType: "json")!
        let jsonString = try! String(contentsOfFile: path)
        dummyData = jsonString.data(using: .utf8)!
    }
    
    private func makeResultValues(of condition: NetworkError?) -> (Data?, HTTPURLResponse?, NetworkError?) {
        switch condition {
        case .sessionError:
            return (nil, nil, .sessionError)
        case .responseIsNil:
            return (nil, nil, nil)
        case .unexpectedResponse:
            return (nil, HTTPURLResponse(url: url, statusCode: 300, httpVersion: "2", headerFields: nil), nil)
        case .unexpectedData:
            return (nil, HTTPURLResponse(url: url, statusCode: 200, httpVersion: "2", headerFields: nil), nil)
        case .status_200:
            return (dummyData, HTTPURLResponse(url: url, statusCode: 200, httpVersion: "2", headerFields: nil), nil)
        case .status_400:
            return (nil, HTTPURLResponse(url: url, statusCode: 404, httpVersion: "2", headerFields: nil), nil)
        case .status_500:
            return (nil, HTTPURLResponse(url: url, statusCode: 501, httpVersion: "2", headerFields: nil), nil)
        default:
            return (nil, nil, nil)
        }
    }
    
    func dataTask(
        with urlReqeust: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    -> URLSessionDataTaskProtocol {
        let dataTask = MockURLSessionDataTask()
        dataTask.resumDidCall = {
            let resultValue = self.makeResultValues(of: self.condition)
            completionHandler(resultValue.0, resultValue.1, resultValue.2)
        }
        return dataTask
    }
}
