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
    
    private var isZooming = false
    
    // MARK: - View Define
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    // MARK: - View LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupGesture()
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
        setupPhotoImageView()
    }
    
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
    
    // MARK: - Gesture
    
    private func setupGesture() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinch(_:)))
        photoImageView.addGestureRecognizer(pinch)
    }
    
    @objc func pinch(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began {
            let currentScale = self.photoImageView.frame.size.width / self.photoImageView.bounds.size.width
            let newScale = currentScale * sender.scale
            
            if newScale > 1 {
                self.isZooming = true
                self.superview?.bringSubviewToFront(self)
            }
        }
        else if sender.state == .changed {
            guard let view = sender.view else {
                return
            }
            
            let pinchCenter = CGPoint(x: sender.location(in: view).x - view.bounds.midX,
                                      y: sender.location(in: view).y - view.bounds.midY)
            let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                .scaledBy(x: sender.scale, y: sender.scale)
                .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
            
            let currentScale = self.photoImageView.frame.size.width / self.photoImageView.bounds.size.width
            var newScale = currentScale * sender.scale
            
            if newScale < 1 {
                newScale = 1
                let transform = CGAffineTransform(scaleX: newScale, y: newScale)
                self.photoImageView.transform = transform
                sender.scale = 1
            } else {
                view.transform = transform
                sender.scale = 1
            }
        }
        else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            UIView.animate(withDuration: 0.3, animations: {
                self.photoImageView.transform = CGAffineTransform.identity
            }, completion: { _ in
                self.isZooming = false
            })
        }
    }
}
