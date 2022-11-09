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
        
        mainView.photo = photo
    }
    
    // MARK: - Layout
    
//    private func setupView() {
//        view.backgroundColor = .systemBackground
//        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss(_:))))
//
//        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
//        doubleTapGesture.numberOfTapsRequired = 2
//
//        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//        singleTapGesture.require(toFail: doubleTapGesture)
//
//        view.addGestureRecognizer(singleTapGesture)
//        view.addGestureRecognizer(doubleTapGesture)
//    }

    
    // MARK: - Objc
    
    @objc private func handleDismiss(_ gesture: UIPanGestureRecognizer) {
        let width: CGFloat = 100
        let height: CGFloat = 200
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .began:
            break
        case .changed:
            view.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
        case .ended:
            if translation.x > width || translation.y > height || translation.x < -width {
                dismiss(animated: true)
            } else {
                UIView.animate(withDuration: 0.5) {
                    self.view.transform = .identity
                }
            }
        default: break
        }
    }
    
//    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
//        isLabelButtonHidden.toggle()
//        UIView.animate(withDuration: 0.5) {
//            self.exitButton.alpha = self.isLabelButtonHidden ? 0 : 1
//            self.titleLabel.alpha = self.isLabelButtonHidden ? 0 : 1
//            self.heartButton.alpha = self.isLabelButtonHidden ? 0 : 1
//            self.downloadButton.alpha = self.isLabelButtonHidden ? 0 : 1
//        }
//    }
//
//    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
//        let scale = min(scrollView.zoomScale * 2, scrollView.maximumZoomScale)
//
//        if scale != scrollView.zoomScale {
//            let tapPoint = gesture.location(in: photoImageView)
//            let size = CGSize(width: scrollView.frame.size.width / scale,
//                              height: scrollView.frame.size.height / scale)
//            let origin = CGPoint(x: tapPoint.x - size.width / 2,
//                                 y: tapPoint.y - size.height / 2)
//            scrollView.zoom(to: CGRect(origin: origin, size: size), animated: true)
//        } else {
//            scrollView.zoom(to: scrollView.frame, animated: true)
//        }
//    }
}
