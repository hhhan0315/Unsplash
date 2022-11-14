# 3. 네트워크, 코어데이터 로직 분리
## 네트워크 로직 분리

```swift
private func getListPhotos() {
    page += 1
    
    apiService.request(api: .getListPhotos(page: page), dataType: [Photo].self) { [weak self] result in
        switch result {
        case .success(let photos):
            self?.mainView.photos += photos
        case .failure(let apiError):
            DispatchQueue.main.async {
                self?.showAlert(message: apiError.errorDescription)
            }
        }
    }
}
```

- 왜 `weak self`를 사용할까?
    - `escaping closure` : 함수의 종료 이후 실행될 수 있는 클로저
    - 네트워크 요청 -> 함수 종료 -> 네트워크 응답 받음 -> 클로저 실행
    - 현재 네트워크 요청을 처리할 경우 weak self를 지워도 강한 참조는 발생하지 않았다.
    - 하지만 혹시 요청이 빨라서 그런 것은 아닐까 sleep 메서드를 활용해 시간이 좀 더 오래 걸리는 경우로 생각해봤다.
    - 현재 프로젝트 중 TopicListViewController -> TopicPhotoListViewController 화면 전환 중에 PinterestPhotoListView의 deinit이 잘 호출되는지 확인해봤다.
    |weak self|strong self|
    |--|--|
    |![1](https://github.com/hhhan0315/Unsplash/blob/main/screenshot/MVC_step3_1.gif)|![2](https://github.com/hhhan0315/Unsplash/blob/main/screenshot/MVC_step3_2.gif)|
    |해당 화면이 사라질 때 바로 deinit|해당 화면이 사라져도 글로벌 큐에서 작동하던 것이 강한 참조하고 있어서 종료되고 deinit|
    - 사용하지 않아도 큰 문제가 발생하지는 않지만 해당 객체가 소멸되는지의 타이밍이 달라질 수 있어서 `weak self`를 사용하는 것이 좋아보인다.
    
### API

```swift
enum API {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    case getListPhotos(page: Int)
    case getListTopics
    case getTopicPhotos(slug: String, page: Int)
    case getSearchPhotos(query: String, page: Int)
    
    var method: HTTPMethod {
        return .get
    }
    
    var baseURL: String {
        return "https://api.unsplash.com"
    }
    
    var path: String {
        switch self {
        case .getListPhotos:
            return "/photos"
        case .getListTopics:
            return "/topics"
        case .getTopicPhotos(let slug, _):
            return "/topics/\(slug)/photos"
        case .getSearchPhotos:
            return "/search/photos"
        }
    }
    
    var query: [String: String]? {
        switch self {
        case .getListPhotos(let page):
            return ["page": "\(page)", "per_page": "\(Constants.perPage)"]
        case .getListTopics:
            return nil
        case .getTopicPhotos(_, let page):
            return ["page": "\(page)", "per_page": "\(Constants.perPage)"]
        case let .getSearchPhotos(query, page):
            return ["query": query, "page": "\(page)", "per_page": "\(Constants.perPage)"]
        }
    }
    
    var header: [String: String] {
        return ["Authorization": "Client-ID \(Secrets.clientID)"]
    }
}
```

- Moya 라이브러리 중 TargetType 스타일 착안해서 제작
- 통신에 필요한 정보 정의
- String 값으로 주소 전체를 관리하는 것이 아니라 열거형 케이스별로 구분해두니까 훨씬 가독성이 좋아졌다.
- 열거형
    - 한정된 사례 안에서 정의할 수 있는 타입
    - 가독성 및 안정성이 높아진다.

### APISerivce

```swift
final class APIService: APIServiceProtocol {
    var urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func request<T: Decodable>(api: API,
                               dataType: T.Type,
                               completion: @escaping (Result<T, APIError>) -> Void) {
        guard var urlComponents = URLComponents(string: api.baseURL + api.path) else {
            completion(.failure(.invalidURLError))
            return
        }
        
        urlComponents.queryItems = api.query?.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = urlComponents.url else {
            completion(.failure(.invalidURLError))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = api.method.rawValue
        urlRequest.allHTTPHeaderFields = api.header
        
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.unknownError))
                return
            }
            
            if error != nil {
                completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidDataError))
                return
            }
            
            do {
                let decodeData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodeData))
            } catch {
                completion(.failure(.decodeError))
            }
        }
        
        task.resume()
    }
}
```

- Decodable을 준수하는 제네릭 설정
- 제네릭을 사용하며 객체의 타입을 dataType 파라미터로 받는다.
    - 타입의 경우마다 모두 정의해야 하는 일을 제네릭을 사용하면 편하게 구현할 수 있다.
- Result 타입을 리턴해주는 클로저
    - 에러가 발생하는 경우 throw하는 것이 아니라 Result 타입을 사용해서 성공과 실패의 정보를 함께 리턴
    - 결과를 처리하는 곳에서도 switch 문으로 깔끔하게 구현할 수 있다.

## 코어데이터 로직 분리

- Core Data
    - 객체 그래프를 관리하는 Framework
    - 여러가지 기능 중의 하나인 Persistence를 통해 영구적으로 저장할 수 있다.
    - 중요한 것은 Core Data의 기능 중 하나를 사용하는 것이며 `Core Data == DB`는 아니다.

```swift
final class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    // NSPersistentContainer : Core Data Stack을 나타내는 필요한 모든 객체
    // AppDelegate에 보통 생성되는데 따로 Manager 클래스에서 사용하기로 이동
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.coreDataFileName)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
        
    // NSManagedObjectContext : 생성, 저장, 가져오는 작업 제공
    // 계산속성이며 get 필수 구현
    private var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    // 지연 저장 속성을 사용하는 것이기 때문에 똑같이 지연 저장 속성을 사용하거나
    // 위처럼 계산 속성은 실제로 메서드 형태로 동작하기 때문에 위의 형태도 가능하다.
//    private lazy var context = self.persistentContainer.viewContext
        
    func fetchPhotoFromCoreData() -> [PhotoData] {
        let request = PhotoData.fetchRequest()
        let dateOrder = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [dateOrder]
        
        do {
            let fetchResult = try context.fetch(request)
            return fetchResult
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}
```

- lazy
    - 해당 속성에 접근하는 순간 초기화 진행
    - 다른 속성들을 이용할 때 사용
- 계산 속성
    - 겉모습은 속성이지만 내부는 메서드 형태로 동작
    - 해당 속성에 접근했을 경우 다른 속성에 접근해서 계산 후 리턴

- 싱글톤 패턴
    - 생성자가 여러 차례 호출되어도 객체는 하나다.
    - 다양한 객체들이 모두 같은 인스턴스와 소통할 수 있다.
    - 단점으로는 인스턴스들 간에 결합도가 높아져서 OCP(Open Closed Principle)을 위배할 수 있다.
    - OCP : 확장에는 열려 있고 변경에는 닫혀 있어야 한다.

- 싱글톤 선택 이유
    - https://developer.apple.com/documentation/coredata/setting_up_a_core_data_stack
    - 해당 글을 보면 AppDelegate에 NSPersistentContainer를 생성하고 사용하는 ViewController에 앱 실행이 완료되면 속성으로 설정해준다.
    - 화면 전환시에도 속성을 전달해준다.
    - 결국 하나의 container로 전달해주는 것이 중요하다고 생각했다.
    - CoreDataManager에 NSPersistentContainer를 가지고 있기 때문에 싱글톤 패턴을 활용해 하나의 객체로 만들어 사용하는 것이 올바른 방법이라고 생각해 선택했다.
