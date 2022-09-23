# 네트워크 객체
# enum API
- Moya TargetType 스타일을 참고
- 네트워크 통신을 하면서 기본적인 정보를 저장하는 역할
- case문을 사용함으로 각 주소별로 필요한 정보를 저장할 수 있다.

```swift
enum API {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    case getPhotos(page: Int)
    
    var method: HTTPMethod {
        return .get
    }
    
    var baseURL: String {
        return "https://api.unsplash.com"
    }
    
    var path: String {
        switch self {
        case .getPhotos:
            return "/photos"
        }
    }
    
    var query: [String: String] {
        switch self {
        case let .getPhotos(page):
            return ["page": "\(page)", "per_page": "\(Query.perPage)"]
        }
    }
    
    var header: [String: String] {
        return ["Authorization": "Client-ID \(Secrets.clientID)"]
    }
}
```

# APICaller

```swift
final class APICaller {
    var urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func request<T: Decodable>(api: API,
                               dataType: T.Type,
                               completion: @escaping (Result<T, APIError>) -> Void) {
        // 생략
    }
}
```

- URLSessionProtocol 의존성 주입을 통해 URLSession을 test 환경에서는 다른걸 사용할 수 있도록 구현했다.
- request 시 API Enum을 활용해 URLRequest로 dataTask를 처리하며 dataType을 통해 decode된 결과값을 리턴해준다.

# Test
- 네트워크 통신이 되지 않더라도 테스트를 할 수 있는 환경을 구현할 수 있었다.
- Mock
    - 실제 객체와 비슷하게 구현된 수준의 객체, 행위 기반 테스트
- Test Double
    - Dummy, Stub, Fake, Spy, Mock
    - 명확하게 구분하면서 사용하면 테스트를 읽기 쉽다는 장점이 있다.
    - Mock을 전체 Test Double을 명칭하며 사용하기도 한다.
    
```swift
func test_request호출시_성공하는지() {
    // given
    let data = """
    [
        {
            "id": "id_example",
            "width": 100,
            "height": 200,
            "urls": {
                "raw": "raw_example",
                "full": "full_example",
                "regular": "regular_example",
                "small": "small_example",
                "thumb": "thumb_example"
            },
            "user": {
                "name": "name_example"
            }
        }
    ]
    """.data(using: .utf8)!
    
    let mockURLSession = MockURLSession.make(url: URL(string: "test.com")!, data: data, statusCode: 200)
    sut.urlSession = mockURLSession
    
    // when
    var result: [PhotoEntity]?
    sut.request(api: .getPhotos(page: 1),
                dataType: [PhotoEntity].self) { response in
        if case let .success(photoEntities) = response {
            result = photoEntities
        }
    }
    
    // then
    let expectation = "name_example"
    XCTAssertNotNil(result)
    XCTAssertEqual(result?.first?.user.name, expectation)
}
```

- 참고
    - https://yagom.net/courses/unit-test-작성하기/
    - https://sujinnaljin.medium.com/swift-mock-을-이용한-network-unit-test-하기-a69570defb41
