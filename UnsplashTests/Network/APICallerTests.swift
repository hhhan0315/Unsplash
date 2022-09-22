//
//  APICallerTests.swift
//  UnsplashTests
//
//  Created by rae on 2022/09/22.
//

import XCTest
@testable import Unsplash

final class APICallerTests: XCTestCase {
    var sut: APICaller!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = APICaller()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_request호출시_성공하는지() {
        // given
        let data = """
        [
            {
                "id": "id_example",
                "width": 100,
                "height": 200,
                "urls": {
                    "raw": "raw_example",
                    "full": "full_example",
                    "regular": "regular_example",
                    "small": "small_example",
                    "thumb": "thumb_example"
                },
                "user": {
                    "name": "name_example"
                }
            }
        ]
        """.data(using: .utf8)!
        
        let mockURLSession = MockURLSession.make(url: URL(string: "test.com")!, data: data, statusCode: 200)
        sut.urlSession = mockURLSession
        
        // when
        var result: [PhotoEntity]?
        sut.request(api: .getPhotos(page: 1),
                    dataType: [PhotoEntity].self) { response in
            if case let .success(photoEntities) = response {
                result = photoEntities
            }
        }
        
        // then
        let expectation = "name_example"
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.first?.user.name, expectation)
    }
    
    func test_request호출시_실패하며_serverError_400_발생하는지() {
        // given
        let mockURLSession = MockURLSession.make(url: URL(string: "test.com")!, data: nil, statusCode: 400)
        sut.urlSession = mockURLSession
        
        // when
        var result: APIError?
        sut.request(api: .getPhotos(page: 1),
                    dataType: [PhotoEntity].self) { response in
            if case let .failure(apiError) = response {
                result = apiError
            }
        }
        
        // then
        let expectation = APIError.serverError(statusCode: 400)
        XCTAssertEqual(result?.errorDescription, expectation.errorDescription)
    }
}
