//
//  TopicViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/05/17.
//

import UIKit

final class TopicViewModel {
    private let apiService: APIServiceProtocol
    
    private var topics: [Topic] = []
    private var page = 1
    
    var cellViewModels: [TopicPhotoCellViewModel] = [] {
        didSet {
            reloadCollectionViewClosure?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            showAlertClosure?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var reloadCollectionViewClosure: (() -> Void)?
    var showAlertClosure: (() -> Void)?
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func fetch() {
        apiService.request(api: .getTopics(page: self.page),
                           dataType: [Topic].self) { [weak self] result in
            switch result {
            case .success(let topics):
                self?.topics.append(contentsOf: topics)
                let cellViewModels = topics.compactMap { self?.createCellViewModel(topic: $0) }
                self?.cellViewModels.append(contentsOf: cellViewModels)
            case .failure(let apiError):
                self?.alertMessage = apiError.errorDescription
            }
        }
    }
    
    func getCellViewModel(indexPath: IndexPath) -> TopicPhotoCellViewModel {
        return cellViewModels[indexPath.item]
    }
    
    func createCellViewModel(topic: Topic) -> TopicPhotoCellViewModel {
        return TopicPhotoCellViewModel(id: topic.id,
                                       title: topic.title,
                                       slug: topic.slug,
                                       coverPhotoURL: topic.coverPhoto.urls.small)
    }
}
