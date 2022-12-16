# MVVM 적용 및 진행 과정

<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/mvvm_1.png">

- 앱을 실행했을 때 첫 화면의 viewDidLoad 상태일 때 예시로 적용과정을 설명하려고 합니다.

## 1. View는 ViewModel의 메서드 호출
- MVVM 구조에서 UIViewController가 View의 역할을 한다.
- ViewModel의 input 메서드 중 하나인 viewDidLoad()를 실행시켜준다.

```swift
final class PhotoListViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 생략
        
        viewModel.viewDidLoad()
    }
}
```

## 2. ViewModel은 Repository 프로토콜을 가지고 있다.
- Input, Output 구조를 채택했다.
- 해당 구조의 장점은 View에서 행동하는 것에 따라 알맞게 처리를 해줄 수 있다.


```swift
protocol PhotoListViewModelInput {
    func viewDidLoad()
}

protocol PhotoListViewModelOutput {
    var photos: [Photo] { get }
    var errorMessage: String? { get }
}

final class PhotoListViewModel: PhotoListViewModelInput, PhotoListViewModelOutput {
    private let photoRepository: PhotoRepository
    
    private var page = 0
    
    // MARK: - Output
    
    @Published var photos: [Photo] = []
    @Published var errorMessage: String?
    
    init(photoRepository: PhotoRepository) {
        self.photoRepository = photoRepository
    }
    
    private func fetchPhotoList() {
        self.page += 1
        
        photoRepository.fetchPhotoList(page: self.page) { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photos += photos
            case .failure(let networkError):
                self?.errorMessage = networkError.rawValue
            }
        }
    }
}

// MARK: - Input

extension PhotoListViewModel {
    func viewDidLoad() {
        fetchPhotoList()
    }
}
```

## 3. Repository는 Network에서 데이터 가져오기
- Repository 실제 구현은 Data 계층에서 하고 있기 때문에 의존성의 방향을 내부로 유지하면서 요청을 보낼 수 있다.
- 나중에 가짜 Repository를 구현한다면 단독으로 테스트도 가능하다.

```swift
final class DefaultPhotoRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DefaultPhotoRepository: PhotoRepository {
    func fetchPhotoList(page: Int, completion: @escaping (Result<[Photo], NetworkError>) -> Void) {
        let photoRequestDTO = PhotoRequestDTO(page: page)
        
        networkService.request(api: API.getListPhotos(photoRequestDTO), dataType: [PhotoResponseDTO].self) { result in
            switch result {
            case .success(let photoResponseDTOs):
                let photos = photoResponseDTOs.map { $0.toDomain() }
                completion(.success(photos))
            case .failure(let networkError):
                completion(.failure(networkError))
            }
        }
    }
}
```

## 4. 정보는 다시 View로 흐른다.
- ViewModel의 Output이 변경되면 View에서 해당 값을 구독하고 있기 때문에 변화가 일어난다.

```swift
final class PhotoListViewController: UIViewController {
    // MARK: - Bind
    
    private func bindViewModel() {
        viewModel.$photos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] photos in
                self?.applySnapshot(with: photos)
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard errorMessage != nil else {
                    return
                }
                self?.showAlert(message: errorMessage)
            }
            .store(in: &cancellables)
    }
}
```
