//
//  APIServiceTests.swift
//  UnsplashTests
//
//  Created by rae on 2022/09/22.
//

import XCTest
@testable import Unsplash

final class APIServiceTests: XCTestCase {
    var sut: APIService!
    var data: Data!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = APIService()
        
        let path = Bundle.main.path(forResource: "content", ofType: "json")!
        let jsonString = try! String(contentsOfFile: path)
        data = jsonString.data(using: .utf8)!
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        data = nil
    }
    
    func test_request호출시_성공하는지() {
        // given
        let mockURLSession = MockURLSession.make(url: URL(string: "test.com")!, data: data, statusCode: 200)
        sut.urlSession = mockURLSession
        
        // when
        var result: [Photo]?
        sut.request(api: .getPhotos(page: 1),
                    dataType: [Photo].self) { response in
            if case .success(let photos) = response {
                result = photos
            }
        }
        
        // then
        let expectation = try? JSONDecoder().decode([Photo].self, from: data)
        XCTAssertEqual(result?.count, expectation?.count)
        XCTAssertEqual(result?.first?.id, expectation?.first?.id)
    }
    
    func test_request호출시_실패하며_serverError_400_발생하는지() {
        // given
        let mockURLSession = MockURLSession.make(url: URL(string: "test.com")!, data: nil, statusCode: 400)
        sut.urlSession = mockURLSession
        
        // when
        var result: APIError?
        sut.request(api: .getPhotos(page: 1),
                    dataType: [Photo].self) { response in
            if case .failure(let apiError) = response {
                result = apiError
            }
        }
        
        // then
        let expectation = APIError.serverError(statusCode: 400)
        XCTAssertEqual(result?.errorDescription, expectation.errorDescription)
    }
    
    func test_request호출시_실패하며_decodeError_발생하는지() {
        // given
        let mockURLSession = MockURLSession.make(url: URL(string: "test.com")!, data: data, statusCode: 200)
        sut.urlSession = mockURLSession
        
        // when
        var result: APIError?
        sut.request(api: .getPhotos(page: 1),
                    dataType: Search.self) { response in
            if case .failure(let apiError) = response {
                result = apiError
            }
        }
        
        // then
        let expectation = APIError.decodeError
        XCTAssertEqual(result?.errorDescription, expectation.errorDescription)
    }
}
