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

## APISerivce

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
