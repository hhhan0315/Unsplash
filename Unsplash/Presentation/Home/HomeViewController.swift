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
    
    private let photoTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        tableView.register(HomeTableLoadingCell.self, forCellReuseIdentifier: HomeTableLoadingCell.identifier)
        return tableView
    }()
    
    // MARK: - Properties
    
    private let viewModel = HomeViewModel()
    private var cancellable = Set<AnyCancellable>()
            
    enum TableSection: Int, CaseIterable {
        case photos = 0
        case loading = 1
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
        viewModel.$range
            .receive(on: DispatchQueue.main)
            .sink { range in
                guard let range = range else {
                    return
                }
                let indexPaths = range.map { IndexPath(row: $0, section: TableSection.photos.rawValue) }
                self.photoTableView.insertRows(at: indexPaths, with: .none)
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

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tableSection = TableSection(rawValue: section) else {
            return 0
        }
        switch tableSection {
        case .photos:
            return viewModel.photosCount()
        case .loading:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableSection = TableSection(rawValue: indexPath.section) else {
            return .init()
        }
        
        switch tableSection {
        case .photos:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else {
                return .init()
            }
            
            let photo = viewModel.photo(at: indexPath.row)
            cell.configureCell(with: photo)
            
            return cell
        case .loading:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableLoadingCell.identifier, for: indexPath) as? HomeTableLoadingCell else {
                return .init()
            }
            cell.animate(isLoading: true)
            
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let tableSection = TableSection(rawValue: indexPath.section) else {
            return 0
        }
        
        switch tableSection {
        case .photos:
            let cellWidth = view.bounds.width
            let imageHeight = CGFloat(viewModel.photo(at: indexPath.row).height)
            let imageWidth = CGFloat(viewModel.photo(at: indexPath.row).width)
            let imageRatio = imageHeight / imageWidth
            
            return imageRatio * cellWidth
        case .loading:
            return 44.0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.photosCount() - 1 {
            viewModel.fetch()
        }
    }
}
