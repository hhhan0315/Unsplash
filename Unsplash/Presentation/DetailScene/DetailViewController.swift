//
//  DetailViewController.swift
//  Unsplash
//
//  Created by rae on 2022/05/03.
//

import UIKit
import Kingfisher
import SnapKit
import RxSwift
import RxCocoa

final class DetailViewController: UIViewController {
    
    // MARK: - View Define
    
    private let exitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "multiply"), for: .normal)
        button.tintColor = .label
        button.setPreferredSymbolConfiguration(.init(scale: .large), forImageIn: .normal)
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
    private var disposeBag = DisposeBag()
    
    private let imageSaver = ImageSaver()
    
    private var isLabelButtonHidden = false
    
    // MARK: - View LifeCycle
    
    init(photo: Photo, viewModel: DetailViewModel) {
        self.photo = photo
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        bindViewModel()
        
        imageSaver.delegate = self
        
        titleLabel.text = photo.user.name
        guard let url = URL(string: photo.urls.regular) else {
            return
        }
        photoImageView.kf.setImage(with: url)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        downloadButton.layer.cornerRadius = downloadButton.frame.width / 2
        downloadButton.clipsToBounds = true
        
        heartButton.layer.cornerRadius = heartButton.frame.width / 2
        heartButton.clipsToBounds = true
    }
    
    // MARK: - Layout
    
    private func setupViews() {
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
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        singleTapGesture.require(toFail: doubleTapGesture)
        
        view.addGestureRecognizer(singleTapGesture)
        view.addGestureRecognizer(doubleTapGesture)
    }
    
    private func setupExitButton() {
        view.addSubview(exitButton)
        exitButton.snp.makeConstraints { make in
            make.top.equalTo(view).offset(50.0)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16.0)
            make.height.equalTo(44.0)
        }
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(exitButton)
            make.centerX.equalTo(view)
            make.height.equalTo(exitButton)
        }
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupPhotoImageView() {
        scrollView.addSubview(photoImageView)
        photoImageView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.width.height.equalTo(scrollView)
        }
    }
    
    private func setupDownloadButton() {
        view.addSubview(downloadButton)
        downloadButton.snp.makeConstraints { make in
            make.width.height.equalTo(60.0)
            make.bottom.equalTo(view).offset(-50.0)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-8.0)
        }
    }
    
    private func setupHeartButton() {
        view.addSubview(heartButton)
        heartButton.snp.makeConstraints { make in
            make.width.height.equalTo(downloadButton)
            make.bottom.equalTo(downloadButton.snp.top).offset(-16.0)
            make.trailing.equalTo(downloadButton)
        }
    }
    
    private func setupActivityIndicatorView() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { make in
            make.width.height.equalTo(50.0)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(8.0)
            make.bottom.equalTo(downloadButton)
        }
    }
    
    // MARK: - Bind
    
    private func bindViewModel() {
        let input = DetailViewModel.Input(
            exitButtonEvent: exitButton.rx.tap.asObservable(),
            downloadButtonEvent: downloadButton.rx.tap.asObservable(),
            heartButtonEvent: heartButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        
        viewModel.showHeartButtonStateClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let isHeartSelected = self?.viewModel.isHeartSelected else {
                    return
                }
                self?.heartButton.tintColor = isHeartSelected ? .red : .systemBackground
            }
        }
        
        viewModel.showAlertClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let alertMessage = self?.viewModel.alertMessage else {
                    return
                }
                self?.showAlert(message: alertMessage)
            }
        }
        
        viewModel.fetchHeartSelected()
    }
    
    // MARK: - Objc
    
    @objc private func touchDownloadButton(_ sender: UIButton) {
        activityIndicatorView.startAnimating()
        
//        imageLoader.load(with: photoCellViewModel.imageURL) { data in
//            if let image = UIImage(data: data) {
//                self.imageSaver.writeToPhotoAlbum(image: image)
//            }
//        }
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
