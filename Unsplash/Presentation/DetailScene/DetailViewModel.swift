//
//  DetailViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/09/28.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailViewModel: ViewModelType {
    weak var coordinator: DetailCoordinator?
    
    // publishRelay : 구독 이후의 동작들을 받아들임
    // ViewController에서 transform을 실행하고 subscribe하기 때문에 기존의 값을 전달해주기 위해 BehaviorRelay를 사용해야 함
    private let heartState = BehaviorRelay<Bool>(value: false)
    private let alertMessage = PublishRelay<String>()
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let exitButtonEvent: Observable<Void>
        let downloadButtonEvent: Observable<Void>
        let heartButtonEvent: Observable<Void>
    }
    // gesture로 사라지는 것도 dismiss 처리 필요
    
    struct Output {
        let heartState: Observable<Bool>
        let alertMessage: Observable<String>
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] _ in
                self?.fetchHeartState()
            })
            .disposed(by: disposeBag)
        
        input.exitButtonEvent
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.finish()
            })
            .disposed(by: disposeBag)
        
        input.heartButtonEvent
            .subscribe(onNext: { [weak self] _ in
                self?.fetchPhotoLike()
            })
            .disposed(by: disposeBag)
        
        return Output(
            heartState: heartState.asObservable(),
            alertMessage: alertMessage.asObservable()
        )
    }
    private var photo: Photo
    
//    private let imageLoader = ImageLoader()
    private let coreDataManager = CoreDataManager()
    
    init(photo: Photo) {
        self.photo = photo
    }
    
    private func fetchHeartState() {
        coreDataManager.isExistPhotoCoreData(id: photo.id) { [weak self] result in
            switch result {
            case .success(let isExist):
                self?.heartState.accept(isExist)
            case .failure(let error):
                self?.alertMessage.accept(error.localizedDescription)
            }
        }
    }
    
    private func fetchPhotoLike() {
        coreDataManager.isExistPhotoCoreData(id: photo.id) { [weak self] result in
            switch result {
            case .success(let isExist):
                if isExist {
                    self?.deletePhotoCoreData()
                } else {
                    self?.savePhotoCoreData()
                }
                self?.postNotificationHeart()
            case .failure(let error):
                self?.alertMessage.accept(error.localizedDescription)
            }
        }
    }
    
    private func deletePhotoCoreData() {
        self.coreDataManager.deletePhotoCoreData(photo: self.photo) { result in
            switch result {
            case .success(let success):
                if success {
                    self.heartState.accept(false)
                }
            case .failure(let error):
                self.alertMessage.accept(error.localizedDescription)
            }
        }
    }
    
    private func savePhotoCoreData() {
        self.coreDataManager.savePhotoCoreData(photo: self.photo) { result in
            switch result {
            case .success(let success):
                if success {
                    self.heartState.accept(true)
                }
            case .failure(let error):
                self.alertMessage.accept(error.localizedDescription)
            }
        }
    }
    
    private func postNotificationHeart() {
        NotificationCenter.default.post(name: Notification.Name.heartButtonClicked, object: nil)
    }
}
