//
//  HomeViewModelTests.swift
//  UnsplashTests
//
//  Created by rae on 2022/10/02.
//

import XCTest
@testable import Unsplash

final class HomeViewModelTests: XCTestCase {
    var sut: HomeViewModel!
    var data: Data!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let path = Bundle.main.path(forResource: "content", ofType: "json")!
        let jsonString = try! String(contentsOfFile: path)
        data = jsonString.data(using: .utf8)!
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        data = nil
    }

    func test_fetch_성공_10개_확인() {
        // given
        let mockURLSession = MockURLSession.make(url: URL(string: "test.com")!, data: data, statusCode: 200)
        
        sut = HomeViewModel(apiService: APIService(urlSession: mockURLSession))
        
        // when
        sut.fetch()
        
        // then
        let expectation = try? JSONDecoder().decode([Photo].self, from: data)
        XCTAssertEqual(sut.numberOfCells, expectation?.count)
    }
    
    func test_fetch_실패_알림메시지_확인() {
        // given
        let mockURLSession = MockURLSession.make(url: URL(string: "test.com")!, data: nil, statusCode: 400)
        
        sut = HomeViewModel(apiService: APIService(urlSession: mockURLSession))
        
        // when
        sut.fetch()
        
        // then
        let expectation = APIError.serverError(statusCode: 400)
        XCTAssertEqual(sut.alertMessage, expectation.errorDescription)
    }
}
