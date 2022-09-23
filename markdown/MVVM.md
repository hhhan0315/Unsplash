# MVVM 패턴
# 사용한 이유
- 테스트의 용이성
    - View와 Controller가 합쳐진 ViewController에서 ViewController는 View의 역할, ViewModel은 View에 나타날 데이터 담당으로 나눠지기 때문에 테스트하기에 좋아진다.
- ViewController의 분리
    - ViewController에서 모든 구현을 하던것을 분리할 수 있었다.
    - ViewController는 UI 구현만 담당하고 View에 관한 비즈니스 로직은 ViewModel이 가지는 것으로 구현할 수 있었다.

# 내가 구현한 MVVM
<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/mvvm.png">

- View -> ViewModel -> Service -> Repository
- View(ViewController)
    - ViewModel과 데이터 바인딩으로 연결
    - ViewModel의 값이 변하면 View는 자연스럽게 변한다.
  
    ```swift
    final class HomeViewController: UIViewController {
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
    ```
  
    - Combine을 통해서 Data Binding을 구현했다.
    - ViewModel의 range, error를 관찰하고 있다가 상태 변화 시 View도 변경된다.
- ViewModel
    - Service를 통해 View에서 보여질 데이터 담당
  
    ```swift
    final class HomeViewModel {    
        @Published var range: Range<Int>? = nil
        @Published var error: APIError? = nil
    }
    ```
    
    - 테이블 뷰 업데이트 시 reloadData()가 아닌 insertRows(at:with:)를 사용하기 위해 Service를 통해 성공 시 Range<Int> 값을 업데이트
    - 실패 시 error 값 업데이트
    - 옵셔널로 구현한 이유는 값이 비어있을 경우 초기 실행한 경우를 의미하며 아무런 동작을 하지 않기 위해 사용했다.
  
- Service
    - Repository를 통해 가져온 Entity를 서비스 로직에서 사용하는 Model로 변환
    
    ```swift
    final class PhotoService {        
        private var page: Int = 1
        
        func fetch(completion: @escaping (Result<[Photo], APIError>) -> Void) {
            photoRepository.fetch(page: page) { result in
                switch result {
                case .success(let photoEntities):
                    let photos = photoEntities.map {
                        Photo(id: $0.id,
                              width: $0.width,
                              height: $0.height,
                              url: $0.urls.small,
                              user: $0.user.name)
                    }
                    self.page += 1
                    completion(.success(photos))
                case .failure(let apiError):
                    completion(.failure(apiError))
                }
            }
        }
    }
    ```
    
    - page 변수는 화면에 나타날 데이터가 아니기 때문에 Service에서 처리하도록 구현
    - 서버 데이터인 Entity를 내가 필요한 모델인 Photo로 mapping하는 구현도 포함되어 있다.
    
- Repository
    - Entity(Server Model)를 가져오는 역할
    
    ```swift
    final class PhotoRepository {
        private let apiCaller = APICaller()
        
        func fetch(page: Int, completion: @escaping (Result<[PhotoEntity], APIError>) -> Void) {
            apiCaller.request(api: .getPhotos(page: page)) { result in
                switch result {
                case .success(let data):
                    guard let decodedData = try? JSONDecoder().decode([PhotoEntity].self, from: data) else {
                        completion(.failure(.decodeError))
                        return
                    }
                    completion(.success(decodedData))
                case .failure(let apiError):
                    completion(.failure(apiError))
                }
            }
        }
    }
    ```
    
- 참고
    - https://www.youtube.com/watch?v=M58LqynqQHc
