//
//  HomeViewController.swift
//  Unsplash
//
//  Created by rae on 2022/09/21.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - UI Define
    
    private let photoTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - Properties
    
    private let viewModel = HomeViewModel()
    
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
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Unsplash"
    }
    
    private func setupPhotoTableView() {
        photoTableView.dataSource = self
        photoTableView.delegate = self
        
        view.addSubview(photoTableView)
        photoTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            photoTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            photoTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    // MARK: - Bind
    
    private func setupBind() {
        viewModel.fetchSucceed = {
            DispatchQueue.main.async {
                self.photoTableView.reloadData()
            }
        }
                
        viewModel.fetchFail = { apiError in
            DispatchQueue.main.async {
                self.showAlert(message: apiError.errorDescription)
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else {
            return .init()
        }
        
        let photo = viewModel.photos[indexPath.row]
        cell.configureCell(with: photo)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellWidth = view.bounds.width
        let imageHeight = CGFloat(viewModel.photos[indexPath.item].height)
        let imageWidth = CGFloat(viewModel.photos[indexPath.item].width)
        let imageRatio = imageHeight / imageWidth
        
        return imageRatio * cellWidth
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.photos.count - 1 {
            viewModel.fetch()
        }
    }
}
