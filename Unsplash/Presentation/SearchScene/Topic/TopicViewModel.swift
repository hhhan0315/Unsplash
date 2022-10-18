//
//  TopicViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/05/17.
//

import Foundation
import RxSwift
import RxCocoa

final class TopicViewModel: ViewModelType {
    weak var coordinator: TopicCoordinatorDelegate?
    
    private let topics = BehaviorRelay<[Topic]>(value: [])
    private let alertMessage = PublishRelay<String>()
    
    private var page = 0
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let didSelectItemEvent: Observable<Topic>
    }
    
    struct Output {
        let topics: Observable<[Topic]>
        let alertMessage: Observable<String>
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] _ in
                self?.fetch()
            })
            .disposed(by: disposeBag)
        
        input.didSelectItemEvent
            .subscribe(onNext: { [weak self] topic in
                self?.coordinator?.pushTopicDetail(with: topic)
            })
            .disposed(by: disposeBag)
        
        return Output(
            topics: topics.asObservable(),
            alertMessage: alertMessage.asObservable()
        )
    }
    
    private func fetch() {
        self.page += 1
        
        apiService.request(api: .getTopics(page: self.page),
                           dataType: [Topic].self) { [weak self] result in
            switch result {
            case .success(let topics):
                self?.topics.accept(topics)
            case .failure(let apiError):
                self?.alertMessage.accept(apiError.errorDescription)
            }
        }
    }
}
