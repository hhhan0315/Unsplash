//
//  MockURLSessionDataTask.swift
//  UnsplashTests
//
//  Created by rae on 2022/09/22.
//

import Foundation
@testable import Unsplash

final class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    
    private let resumeHandler: () -> Void
    
    init(resumeHandler: @escaping () -> Void) {
        self.resumeHandler = resumeHandler
    }
    
    func resume() {
        resumeHandler()
    }
}
