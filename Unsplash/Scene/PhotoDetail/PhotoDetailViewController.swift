//
//  DetailViewController.swift
//  Unsplash
//
//  Created by rae on 2022/05/03.
//

import UIKit

final class PhotoDetailViewController: UIViewController {
    
    // MARK: - View Define
    
    private let mainView = PhotoDetailView()
    
    // MARK: - Private Properties
    
    private let coreDataManager = CoreDataManager.shared
    
    private var photo: Photo
    
    // MARK: - View LifeCycle
    
    init(photo: Photo) {
        self.photo = photo
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
        
        view.backgroundColor = .systemBackground
        
        mainView.listener = self
        mainView.photo = photo
        mainView.heartButtonSelected = coreDataManager.isExistPhotoData(photo: photo) ? true : false
    }
    
    // MARK: - NotificationCenter
    
    private func postNotificationHeart() {
        NotificationCenter.default.post(name: Notification.Name.heartButtonClicked, object: nil)
    }
}

// MARK: - PhotoDetailViewActionListener

extension PhotoDetailViewController: PhotoDetailViewActionListener {
    func photoDetailViewExitButtonDidTap() {
        dismiss(animated: true)
    }
    
    func photoDetailViewHeartButtonDidTap(with photo: Photo) {
        defer {
            postNotificationHeart()
        }
        
        if coreDataManager.isExistPhotoData(photo: photo) {
            coreDataManager.deletePhotoData(photo: photo) {
                self.mainView.heartButtonToggle(state: false)
            }
        } else {
            coreDataManager.insertPhotoData(photo: photo) {
                self.mainView.heartButtonToggle(state: true)
            }
        }
    }
}
