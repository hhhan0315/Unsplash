//
//  DetailViewController.swift
//  Unsplash
//
//  Created by rae on 2022/05/03.
//

import UIKit

final class DetailViewController: UIViewController {
    
    // MARK: - View Define
    
    private lazy var exitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "multiply"), for: .normal)
        button.tintColor = .label
        button.setPreferredSymbolConfiguration(.init(pointSize: 20.0), forImageIn: .normal)
        button.addTarget(self, action: #selector(touchExitButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        label.text = photo.user
        return label
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
        
    private let imageSaver = ImageSaver()
    private let imageLoader = ImageLoader()
    
    // MARK: - View LifeCycle
    
    init(photo: Photo) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
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
        setupPhotoImageView()
        setupDownloadButton()
        setupHeartButton()
        setupActivityIndicatorView()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        //        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss(_:))))
    }
    
    private func setupExitButton() {
        view.addSubview(exitButton)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            exitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            exitButton.heightAnchor.constraint(equalToConstant: 44.0),
        ])
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 44.0),
        ])
    }
    
    private func setupPhotoImageView() {
        view.addSubview(photoImageView)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func setupDownloadButton() {
        view.addSubview(downloadButton)
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            downloadButton.widthAnchor.constraint(equalToConstant: 60.0),
            downloadButton.heightAnchor.constraint(equalToConstant: 60.0),
            downloadButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
            downloadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32.0),
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
        sender.isSelected.toggle()
        sender.tintColor = sender.isSelected ? .red : .systemBackground
    }
}

// MARK: - ImageSaverDelegate

extension DetailViewController: ImageSaverDelegate {
    func saveFailure() {
        let alertController = UIAlertController(title: "Photo Library Access Denied", message: "Allow Photos access in Settings to save photos to your Photo Library", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }))
        present(alertController, animated: true)
        activityIndicatorView.stopAnimating()
    }
    
    func saveSuccess() {
        showAlert(title: "저장 성공")
        activityIndicatorView.stopAnimating()
    }
}
