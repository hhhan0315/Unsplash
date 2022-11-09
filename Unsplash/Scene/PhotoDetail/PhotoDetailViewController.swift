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
        
        mainView.listener = self
        mainView.photo = photo
    }
}

// MARK: - PhotoDetailViewActionListener

extension PhotoDetailViewController: PhotoDetailViewActionListener {
    func photoDetailViewExitButtonDidTap() {
        dismiss(animated: true)
    }
    
    func photoDetailViewHeartButtonDidTap() {
        
    }
}
