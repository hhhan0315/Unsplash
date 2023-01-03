//
//  PhotoListViewModelTests.swift
//  UnsplashTests
//
//  Created by rae on 2022/12/10.
//

import XCTest
import Combine
@testable import Unsplash

final class GetPhotoListUseCaseMock: GetPhotoListUseCase {
    var photos: [Photo] = []
    var error: NetworkError?
    
    func execute(page: Int, completion: @escaping (Result<[Photo], NetworkError>) -> Void) {
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(photos))
        }
    }
}

final class PhotoListViewModelTests: XCTestCase {
    private var sut: PhotoListViewModel?
    private let photosMock: [Photo] = [Photo(identifier: UUID(), id: "photo1", width: 200, height: 200, urls: URLs(regular: "test.com"), links: Links(html: "test"), user: User(name: "test"))]
    private var cancellables = Set<AnyCancellable>()
    
    func test_viewDidLoad시_fetchPhotoList_성공하는지() {
        let getPhotoListUseCaseMock = GetPhotoListUseCaseMock()
        getPhotoListUseCaseMock.photos = self.photosMock
        sut = PhotoListViewModel(getPhotoListUseCase: getPhotoListUseCaseMock)
        
        sut?.viewDidLoad()
        
        XCTAssertEqual(sut?.photos.count, 1)
    }
    
    func test_viewDidLoad시_decodeError발생_실패하는지() {
        let getPhotoListUseCaseMock = GetPhotoListUseCaseMock()
        getPhotoListUseCaseMock.error = .decodeError
        sut = PhotoListViewModel(getPhotoListUseCase: getPhotoListUseCaseMock)
        
        sut?.viewDidLoad()
        
        XCTAssertEqual(sut?.errorMessage, NetworkError.decodeError.rawValue)
    }
    
    func test_photos_bind() {
        let getPhotoListUseCaseMock = GetPhotoListUseCaseMock()
        sut = PhotoListViewModel(getPhotoListUseCase: getPhotoListUseCaseMock)
        
        sut?.photos = photosMock
        
        sut?.$photos
            .sink(receiveValue: { [weak self] photos in
                XCTAssertEqual(self?.photosMock, photos)
            })
            .store(in: &cancellables)
    }
}
