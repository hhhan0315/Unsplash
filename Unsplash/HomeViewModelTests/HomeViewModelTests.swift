//
//  HomeViewModelTests.swift
//  HomeViewModelTests
//
//  Created by rae on 2022/06/06.
//

import XCTest
@testable import Unsplash

class HomeViewModelTests: XCTestCase {
    private var homeViewModel: HomeViewModel!
    
    override func setUp() {
        super.setUp()
        let networkService = NetworkService()
        let defaultTopicPhotoRepository = DefaultTopicPhotoRepository(networkService: networkService)
        let defaultTopicPhotoUseCase = DefaultTopicPhotoUseCase(topicPhotoRepository: defaultTopicPhotoRepository)
        self.homeViewModel = HomeViewModel(topicPhotoUseCase: defaultTopicPhotoUseCase)
    }

    override func tearDown() {
        super.tearDown()
        self.homeViewModel = nil
    }
    
    func testPhotosBind() {
        let testPhotos = [Photo(image: nil, imageUrl: nil, userName: "")]
        self.homeViewModel.photos.value.append(contentsOf: testPhotos)
        self.homeViewModel.photos.observe(on: self) { photos in
            XCTAssertEqual(testPhotos, photos)
        }
    }

    func testPhotosTopic() {
        let topic = Topic.animals
        self.homeViewModel.update(topic)
        XCTAssertEqual(topic, self.homeViewModel.topic)
    }
}
