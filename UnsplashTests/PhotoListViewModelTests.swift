//
//  PhotoListViewModelTests.swift
//  UnsplashTests
//
//  Created by rae on 2022/12/10.
//

import XCTest
import Combine
@testable import Unsplash

final class PhotoRepositoryMock: PhotoRepository {
    var error: NetworkError?
    var photos: [Photo] = []
    
    func fetchPhotoList(page: Int, completion: @escaping (Result<[Photo], NetworkError>) -> Void) {
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(photos))
        }
    }
}

final class PhotoListViewModelTests: XCTestCase {
    private var sut: PhotoListViewModel?
    private let photosMock: [Photo] = [Photo(identifier: UUID(), id: "photo1", width: 200, height: 200, urls: URLs(regular: "test.com"), user: User(name: "test"))]
    private var cancellables = Set<AnyCancellable>()
    
    func test_viewDidLoad시_fetchPhotoList_성공하는지() {
        let photoRepositoryMock = PhotoRepositoryMock()
        photoRepositoryMock.photos = self.photosMock
        sut = PhotoListViewModel(photoRepository: photoRepositoryMock)
        
        sut?.viewDidLoad()
        
        XCTAssertEqual(sut?.photos.count, 1)
    }
    
    func test_viewDidLoad시_decodeError발생_실패하는지() {
        let photoRepositoryMock = PhotoRepositoryMock()
        photoRepositoryMock.error = .decodeError
        sut = PhotoListViewModel(photoRepository: photoRepositoryMock)
        
        sut?.viewDidLoad()
        
        XCTAssertEqual(sut?.errorMessage, NetworkError.decodeError.rawValue)
    }
    
    func test_photos_bind() {
        let photoRepositoryMock = PhotoRepositoryMock()
        
        sut = PhotoListViewModel(photoRepository: photoRepositoryMock)
        
        sut?.photos = photosMock
        
        sut?.$photos
            .sink(receiveValue: { [weak self] photos in
                XCTAssertEqual(self?.photosMock, photos)
            })
            .store(in: &cancellables)
    }
}