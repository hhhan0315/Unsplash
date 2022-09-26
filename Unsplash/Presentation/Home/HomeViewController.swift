//
//  HomeViewController.swift
//  Unsplash
//
//  Created by rae on 2022/09/21.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {
    
    // MARK: - UI Define
    
    private lazy var photoTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        tableView.dataSource = photoDataSource
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - Properties
    
    private let viewModel = HomeViewModel()
    private var cancellable = Set<AnyCancellable>()
    
    private var photoDataSource: UITableViewDiffableDataSource<Section, Photo>?
    
    enum Section {
        case photos
    }
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBind()
        
        viewModel.fetch()
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupPhotoTableView()
        setupPhotoDataSource()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Unsplash"
        navigationItem.backButtonTitle = ""
    }
    
    private func setupPhotoTableView() {
        view.addSubview(photoTableView)
        photoTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            photoTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            photoTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func setupPhotoDataSource() {
        photoDataSource = UITableViewDiffableDataSource(tableView: photoTableView, cellProvider: { tableView, indexPath, photo in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else {
                return .init()
            }
            cell.configureCell(with: photo)
            return cell
        })
    }
    
    // MARK: - Bind
    
    private func setupBind() {
        viewModel.$photos
            .receive(on: DispatchQueue.main)
            .sink { photos in
                var snapShot = NSDiffableDataSourceSnapshot<Section, Photo>()
                snapShot.appendSections([Section.photos])
                snapShot.appendItems(photos)
                self.photoDataSource?.apply(snapShot)
            }
            .store(in: &cancellable)
        
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { apiError in
                guard let apiError = apiError else {
                    return
                }
                self.showAlert(message: apiError.errorDescription)
            }
            .store(in: &cancellable)
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellWidth = view.bounds.width
        let imageHeight = CGFloat(viewModel.photo(at: indexPath.row).height)
        let imageWidth = CGFloat(viewModel.photo(at: indexPath.row).width)
        let imageRatio = imageHeight / imageWidth
        
        return imageRatio * cellWidth
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.photosCount() - 1 {
            viewModel.fetch()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController(photo: viewModel.photo(at: indexPath.item))
        detailViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
