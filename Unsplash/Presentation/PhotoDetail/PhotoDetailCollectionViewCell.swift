//
//  PhotoDetailCollectionViewCell.swift
//  Unsplash
//
//  Created by rae on 2022/12/12.
//

import UIKit

final class PhotoDetailCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    
    static let identifier = String(describing: PhotoDetailCollectionViewCell.self)
    
    var photo: Photo? {
        didSet {
            photoImageView.downloadImage(with: photo)
        }
    }
        
    // MARK: - View Define
    
//    private lazy var scrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.alwaysBounceVertical = false
//        scrollView.alwaysBounceHorizontal = false
//        scrollView.minimumZoomScale = 1.0
//        scrollView.maximumZoomScale = 2.0
//        scrollView.delegate = self
//        return scrollView
//    }()
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - View LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        photoImageView.image = nil
    }
    
    // MARK: - Layout
    
    private func setupViews() {
//        setupScrollView()
        setupPhotoImageView()
    }
    
//    private func setupScrollView() {
//        addSubview(scrollView)
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
//        ])
//    }
    
//    private func setupPhotoImageView() {
//        scrollView.addSubview(photoImageView)
//        photoImageView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            photoImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            photoImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            photoImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            photoImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//            photoImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
//            photoImageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
//        ])
//    }
    
    private func setupPhotoImageView() {
        addSubview(photoImageView)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

// MARK: - UIScrollViewDelegate

//extension PhotoDetailCollectionViewCell: UIScrollViewDelegate {
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return photoImageView
//    }
//}
