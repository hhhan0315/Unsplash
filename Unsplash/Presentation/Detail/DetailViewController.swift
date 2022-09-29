//
//  DetailViewController.swift
//  Unsplash
//
//  Created by rae on 2022/05/03.
//

import UIKit
import Combine

final class DetailViewController: UIViewController {
    
    // MARK: - View Define
    
    private lazy var exitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "multiply"), for: .normal)
        button.tintColor = .label
        button.setPreferredSymbolConfiguration(.init(scale: .large), forImageIn: .normal)
        button.addTarget(self, action: #selector(touchExitButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        label.text = photo.user
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
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.downloadImage(with: photo.url)
        return imageView
    }()
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        button.backgroundColor = .label
        button.tintColor = .systemBackground
        button.addTarget(self, action: #selector(touchDownloadButton(_:)), for: .touchUpInside)
        button.setPreferredSymbolConfiguration(.init(scale: .large), forImageIn: .normal)
        return button
    }()
    
    private lazy var heartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.backgroundColor = .label
        button.tintColor = .systemBackground
        button.addTarget(self, action: #selector(touchHeartButton(_:)), for: .touchUpInside)
        button.setPreferredSymbolConfiguration(.init(scale: .large), forImageIn: .normal)
        return button
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView()
        activityView.style = .large
        return activityView
    }()
    
    // MARK: - Properties
    
    private var photo: Photo
    
    private let viewModel: DetailViewModel
    private var cancellable = Set<AnyCancellable>()
    
    private let imageSaver = ImageSaver()
    private let imageLoader = ImageLoader()
    
    private var isLabelButtonHidden = false
    
    // MARK: - View LifeCycle
    
    init(photo: Photo) {
        self.photo = photo
        self.viewModel = DetailViewModel(photo: photo)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBind()
        imageSaver.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        downloadButton.layer.cornerRadius = downloadButton.frame.width / 2
        downloadButton.clipsToBounds = true
        
        heartButton.layer.cornerRadius = heartButton.frame.width / 2
        heartButton.clipsToBounds = true
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        setupView()
        setupExitButton()
        setupTitleLabel()
        setupScrollView()
        setupPhotoImageView()
        setupDownloadButton()
        setupHeartButton()
        setupActivityIndicatorView()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss(_:))))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
    }
    
    private func setupExitButton() {
        view.addSubview(exitButton)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50.0),
            exitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            exitButton.heightAnchor.constraint(equalToConstant: 44.0),
        ])
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: exitButton.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 44.0),
        ])
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
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
    
    private func setupDownloadButton() {
        view.addSubview(downloadButton)
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            downloadButton.widthAnchor.constraint(equalToConstant: 60.0),
            downloadButton.heightAnchor.constraint(equalToConstant: 60.0),
            downloadButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
            downloadButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50.0),
        ])
    }
    
    private func setupHeartButton() {
        view.addSubview(heartButton)
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heartButton.widthAnchor.constraint(equalToConstant: 60.0),
            heartButton.heightAnchor.constraint(equalToConstant: 60.0),
            heartButton.bottomAnchor.constraint(equalTo: downloadButton.topAnchor, constant: -16.0),
            heartButton.trailingAnchor.constraint(equalTo: downloadButton.trailingAnchor),
        ])
    }
    
    private func setupActivityIndicatorView() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 50.0),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 50.0),
            activityIndicatorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8.0),
            activityIndicatorView.bottomAnchor.constraint(equalTo: downloadButton.bottomAnchor),
        ])
    }
    
    // MARK: - Bind
    
    private func setupBind() {
        viewModel.$isHeartSelected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isHeartSelected in
                self?.heartButton.tintColor = isHeartSelected ? .red : .systemBackground
            }
            .store(in: &cancellable)
        
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let error = error else {
                    return
                }
                self?.showAlert(message: error.localizedDescription)
            }
            .store(in: &cancellable)
    }
    
    // MARK: - Objc
    
    @objc private func touchExitButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc private func touchDownloadButton(_ sender: UIButton) {
        activityIndicatorView.startAnimating()
        
        imageLoader.load(with: photo.url) { data in
            if let image = UIImage(data: data) {
                self.imageSaver.writeToPhotoAlbum(image: image)
            }
        }
    }
    
    @objc private func touchHeartButton(_ sender: UIButton) {
        viewModel.fetchPhotoLike()
    }
    
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
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        isLabelButtonHidden.toggle()
        UIView.animate(withDuration: 0.5) {
            self.exitButton.alpha = self.isLabelButtonHidden ? 0 : 1
            self.titleLabel.alpha = self.isLabelButtonHidden ? 0 : 1
            self.heartButton.alpha = self.isLabelButtonHidden ? 0 : 1
            self.downloadButton.alpha = self.isLabelButtonHidden ? 0 : 1
        }
    }
}

// MARK: - ImageSaverDelegate

extension DetailViewController: ImageSaverDelegate {
    func saveFailure() {
        showPhotoSettingAlert()
        activityIndicatorView.stopAnimating()
    }
    
    func saveSuccess() {
        showAlert(title: "저장 성공")
        activityIndicatorView.stopAnimating()
    }
}

// MARK: - UIScrollViewDelegate

extension DetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
}
