//
//  HeartPhotoListViewController.swift
//  Unsplash
//
//  Created by rae on 2022/09/19.
//

import UIKit

final class LikesPhotoListViewController: UIViewController {
    
    // MARK: - UI Define
    
//    private let mainView = LikesPhotoListView()
    
    // MARK: - Private Properties
    
    private let coreDataManager = CoreDataManager.shared
    
    // MARK: - View LifeCycle
    
//    override func loadView() {
//        self.view = mainView
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.title = "Likes"
        
//        mainView.listener = self
        
        setupNotificationCenter()
        
        getLikesPhotos()
    }
    
    // MARK: - NotificationCenter
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: Notification.Name.heartButtonClicked, object: nil)
    }
    
    // MARK: - Objc
    
    @objc private func refresh() {
        getLikesPhotos()
    }
    
    // MARK: - Networking
    
    private func getLikesPhotos() {
//        let photoData = coreDataManager.fetchPhotoFromCoreData()
//        let photos = photoData.map {
//            Photo(id: $0.id ?? "",
//                  width: CGFloat($0.width),
//                  height: CGFloat($0.height),
//                  urls: Photo.URLs(raw: "", full: "", regular: $0.url ?? "", small: "", thumb: ""),
//                  user: Photo.User(name: $0.user ?? ""))
//        }
//        
//        mainView.photos = photos
    }
}

// MARK: - PhotoListDelegateActionListener

//extension LikesPhotoListViewController: LikesPhotoListViewActionListener {
//    func likesPhotoListViewCellDidTap(with photo: Photo) {
//        let photoDetailViewController = PhotoDetailViewController(photo: photo)
//        present(photoDetailViewController, animated: true)
//    }
//}
//