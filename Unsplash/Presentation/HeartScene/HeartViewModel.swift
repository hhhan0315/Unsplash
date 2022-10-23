//
//  HeartViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/09/28.
//

import Foundation
import RxSwift
import RxCocoa

final class HeartViewModel: ViewModelType {
    weak var coordinator: HeartCoordinator?
    
    private let coreDataManager = CoreDataManager()
    
    private let photos = BehaviorRelay<[Photo]>(value: [])
    private let alertMessage = PublishRelay<String>()
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let didSelectItemEvent: Observable<Photo>
    }
    
    struct Output {
        let photos: Observable<[Photo]>
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] in
                self?.fetch()
            })
            .disposed(by: disposeBag)
        
        input.didSelectItemEvent
            .subscribe(onNext: { [weak self] photo in
                self?.coordinator?.presentDetail(with: photo)
            })
            .disposed(by: disposeBag)
        
        return Output(photos: photos.asObservable())
    }
    
    func fetch() {
        coreDataManager.fetchPhotoCoreData { [weak self] result in
            switch result {
            case .success(let photoCoreData):
                let photos = photoCoreData.map {
                    Photo(id: $0.id ?? "",
                          width: CGFloat($0.width),
                          height: CGFloat($0.height),
                          urls: Photo.URLs(raw: "", full: "", regular: $0.url ?? "", small: "", thumb: ""),
                          user: Photo.User(name: $0.user ?? ""))
                }
                self?.photos.accept(photos)
            case .failure(let error):
                self?.alertMessage.accept(error.localizedDescription)
            }
        }
    }
    
    func photo(at index: Int) -> Photo {
        return photos.value[index]
    }
}
