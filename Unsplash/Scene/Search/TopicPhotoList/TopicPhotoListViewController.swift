//
//  TopicPhotoListViewController.swift
//  Unsplash
//
//  Created by rae on 2022/09/24.
//

import UIKit

final class TopicPhotoListViewController: UIViewController {
    
    // MARK: - View Define
    
    private let mainView = PinterestPhotoListView()
    
    // MARK: - Private Properties
    
    private let apiService = APIService()
    
    private var page = 0
    
    private let topic: Topic
        
    // MARK: - View LifeCycle
    
    init(topic: Topic) {
        self.topic = topic
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = topic.title
        
        getTopicListPhotos()
    }
    
    // MARK: - Networking
    
    private func getTopicListPhotos() {
        apiService.request(api: .getTopicPhotos(slug: topic.slug, page: page), dataType: [Photo].self) { [weak self] result in
            switch result {
            case .success(let photos):
                self?.mainView.photos += photos
            case .failure(let apiError):
                DispatchQueue.main.async {
                    self?.showAlert(message: apiError.errorDescription)
                }
            }
        }
    }
}
