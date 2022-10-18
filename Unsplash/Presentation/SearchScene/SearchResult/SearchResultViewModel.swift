//
//  SearchResultViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/09/27.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchResultViewModel: ViewModelType {
    
    private let photos = BehaviorRelay<[Photo]>(value: [])
    private let alertMessage = PublishRelay<String>()
    
    private var query = ""
    private var page = 0
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    struct Input {
        let prefetchItemEvent: Observable<[IndexPath]>
    }
    
    struct Output {
        let photos: Observable<[Photo]>
        let alertMessage: Observable<String>
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        input.prefetchItemEvent
            .compactMap(\.last?.item)
            .subscribe(onNext: { [weak self] item in
                guard let photosCount = self?.photos.value.count else {
                    return
                }
                guard item == photosCount - 1 else {
                    return
                }
                self?.fetch()
            })
            .disposed(by: disposeBag)
        
        return Output(
            photos: photos.asObservable(),
            alertMessage: alertMessage.asObservable()
        )
    }
    
    private func fetch() {
        self.page += 1
        
        apiService.request(api: .getSearch(query: self.query, page: self.page),
                           dataType: Search.self) { [weak self] result in
            switch result {
            case .success(let search):
                let oldPhotos = self?.photos.value ?? []
                self?.photos.accept(oldPhotos + search.results)
            case .failure(let apiError):
                self?.alertMessage.accept(apiError.errorDescription)
            }
        }
    }
    
    func photo(at index: Int) -> Photo {
        return photos.value[index]
    }
    
    func update(_ query: String) {
        guard self.query != query else {
            return
        }
        self.query = query
        self.page = 0
        photos.accept([])
        fetch()
    }
    
    func reset() {
        self.query = ""
        self.page = 0
        photos.accept([])
    }
}
