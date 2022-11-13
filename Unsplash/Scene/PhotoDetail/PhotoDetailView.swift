//
//  PhotoDetailView.swift
//  Unsplash
//
//  Created by rae on 2022/11/08.
//

import UIKit

protocol PhotoDetailViewActionListener: AnyObject {
    func photoDetailViewExitButtonDidTap()
    func photoDetailViewHeartButtonDidTap(with photo: Photo)
}

final class PhotoDetailView: UIView {
    
    // MARK: - View Define
    
    private lazy var exitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "multiply"), for: .normal)
        button.tintColor = .label
        button.setPreferredSymbolConfiguration(.init(scale: .large), forImageIn: .normal)
        button.addTarget(self, action: #selector(touchExitButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
        scrollView.delegate = self
        return scrollView
    }()
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var heartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.backgroundColor = .label
        button.addTarget(self, action: #selector(touchHeartButton(_:)), for: .touchUpInside)
        button.setPreferredSymbolConfiguration(.init(scale: .large), forImageIn: .normal)
        return button
    }()
    
    // MARK: - Private Properties
    
    private var isLabelButtonHidden = false
    
    // MARK: - Internal Properties
    
    weak var listener: PhotoDetailViewActionListener?
    
    var heartButtonSelected: Bool = false {
        didSet {
            heartButton.tintColor = heartButtonSelected ? .red : .systemBackground
        }
    }
    
    var photo: Photo? {
        didSet {
            titleLabel.text = photo?.user.name
            photoImageView.downloadImage(with: photo?.urls.regular ?? "")
        }
    }
    
    // MARK: - View LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
            
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        heartButton.layer.cornerRadius = heartButton.frame.width / 2
        heartButton.clipsToBounds = true
    }
    
    // MARK: - Layout
    
    private func setupViews() {
        backgroundColor = .systemBackground
        
        setupExitButton()
        setupTitleLabel()
        setupScrollView()
        setupPhotoImageView()
        setupHeartButton()
        
        setupGesture()
    }
    
    private func setupExitButton() {
        addSubview(exitButton)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            exitButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16.0),
            exitButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            exitButton.heightAnchor.constraint(equalToConstant: 44.0),
        ])
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: exitButton.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 44.0),
        ])
    }
    
    private func setupScrollView() {
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func setupPhotoImageView() {
        scrollView.addSubview(photoImageView)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            photoImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            photoImageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
        ])
    }
    
    private func setupHeartButton() {
        addSubview(heartButton)
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heartButton.widthAnchor.constraint(equalToConstant: 60.0),
            heartButton.heightAnchor.constraint(equalToConstant: 60.0),
            heartButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50.0),
            heartButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
        ])
    }
    
    private func setupGesture() {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2

        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        singleTapGesture.require(toFail: doubleTapGesture)

        addGestureRecognizer(singleTapGesture)
        addGestureRecognizer(doubleTapGesture)
    }
    
    // MARK: - User Action
    
    @objc private func touchExitButton(_ sender: UIButton) {
        listener?.photoDetailViewExitButtonDidTap()
    }
    
    @objc private func touchHeartButton(_ sender: UIButton) {
        guard let photo = photo else {
            return
        }
        
        listener?.photoDetailViewHeartButtonDidTap(with: photo)
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        isLabelButtonHidden.toggle()
        UIView.animate(withDuration: 0.5) {
            self.exitButton.alpha = self.isLabelButtonHidden ? 0 : 1
            self.titleLabel.alpha = self.isLabelButtonHidden ? 0 : 1
            self.heartButton.alpha = self.isLabelButtonHidden ? 0 : 1
        }
    }

    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        let scale = min(scrollView.zoomScale * 2, scrollView.maximumZoomScale)

        if scale != scrollView.zoomScale {
            let tapPoint = gesture.location(in: photoImageView)
            let size = CGSize(width: scrollView.frame.size.width / scale,
                              height: scrollView.frame.size.height / scale)
            let origin = CGPoint(x: tapPoint.x - size.width / 2,
                                 y: tapPoint.y - size.height / 2)
            scrollView.zoom(to: CGRect(origin: origin, size: size), animated: true)
        } else {
            scrollView.zoom(to: scrollView.frame, animated: true)
        }
    }
    
    func heartButtonToggle(state: Bool) {
        heartButton.tintColor = state ? .red : .systemBackground
    }
}

// MARK: - UIScrollViewDelegate

extension PhotoDetailView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
}
