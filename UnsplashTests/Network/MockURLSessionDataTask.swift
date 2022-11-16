//
//  MockURLSessionDataTask.swift
//  UnsplashTests
//
//  Created by rae on 2022/09/22.
//

import Foundation
@testable import Unsplash

final class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    var resumDidCall: () -> Void = {}
    
    func resume() {
        resumDidCall()
    }
}
