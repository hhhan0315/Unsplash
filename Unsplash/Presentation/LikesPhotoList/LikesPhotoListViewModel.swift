//
//  LikesPhotoListViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/12/13.
//

import Foundation

protocol LikesPhotoListViewModelInput {
    func viewWillAppear()
}

protocol LikesPhotoListViewModelOutput {
    var photos: [Photo] { get }
}

final class LikesPhotoListViewModel: LikesPhotoListViewModelInput, LikesPhotoListViewModelOutput {
    private let photoCoreDataRepository = DefaultPhotoCoreDataRepository()
    
    // MARK: - Output
    
    @Published var photos: [Photo] = []
    
    private func fetchAll() {
        Task {
            let photos = try await photoCoreDataRepository.fetchAll()
            self.photos = photos
        }
    }
}

// MARK: - Input

extension LikesPhotoListViewModel {
    func viewWillAppear() {
        fetchAll()
    }
}
