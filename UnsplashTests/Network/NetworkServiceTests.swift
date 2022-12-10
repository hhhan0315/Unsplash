//
//  NetworkServiceTests.swift
//  UnsplashTests
//
//  Created by rae on 2022/09/22.
//

import XCTest
@testable import Unsplash

final class NetworkServiceTests: XCTestCase {
    var networkService: NetworkService?
    let urlSession = MockURLSession()
    let photoRequestDTO = PhotoRequestDTO(page: 1)
    
    func test_statusCode가_200일경우_Error가_나오지않는지() {
        let expectation = XCTestExpectation()
        var error: NetworkError?
        
        urlSession.condition = .status_200
        
        networkService = NetworkService(urlSession: urlSession)
        networkService?.request(api: API.getListPhotos(photoRequestDTO),
                           dataType: [PhotoResponseDTO].self) { result in
            switch result {
            case .success:
                error = nil
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNil(error)
    }
    
    func test_statusCode가_200일경우_DecodeError가_발생하는지() {
        let expectation = XCTestExpectation()
        var error: NetworkError?
        
        urlSession.condition = .status_200
        
        networkService = NetworkService(urlSession: urlSession)
        networkService?.request(api: API.getListPhotos(photoRequestDTO),
                           dataType: [TopicResponseDTO].self) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let apiError):
                error = apiError
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(error, .decodeError)
    }
    
    func test_statusCode가_400일경우_status400Error가_발생하는지() {
        let expectation = XCTestExpectation()
        var error: NetworkError?
        
        urlSession.condition = .status_400
        
        networkService = NetworkService(urlSession: urlSession)
        networkService?.request(api: API.getListPhotos(photoRequestDTO),
                           dataType: [PhotoResponseDTO].self) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let apiError):
                error = apiError
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(error, .status_400)
    }
    
    func test_unexpectedData일경우_unexpectedData오류가_발생하는지() {
        let expectation = XCTestExpectation()
        var error: NetworkError?
        
        urlSession.condition = .unexpectedData
        
        networkService = NetworkService(urlSession: urlSession)
        networkService?.request(api: API.getListPhotos(photoRequestDTO),
                           dataType: [PhotoResponseDTO].self) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let apiError):
                error = apiError
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(error, .unexpectedData)
    }
}
