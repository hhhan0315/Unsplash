# Mock을 이용한 Network Unit Test
- [참고: 내일 지구가 멸망하더라도 테스트는 같게 동작해야한다.(김찬우) - AsyncSwift Seminar002](https://www.youtube.com/watch?v=Bev67qIA6mY&t=1136s)

## 네트워킹 과정
- URLSession 객체가 만들어진다. -> dataTask 실행 -> URLSessionDataTask 객체 생성 -> resume 실행 -> 서버 다녀옴 -> completionHandler 호출
- 해당 과정이 일관된 과정이 아니다.
    - 서버 다운
    - 와이파이 연결 불안정
- 그래도 우리는 일관된 테스트를 진행해야 한다.
- 우리는 `MockURLSession`, `MockURLSessionDataTask`를 만들어줄 것이다.

## URLSessionProtocol, URLSessionDataTaskProtocol

```swift
typealias DataTaskCompletionHandler = (Data?, URLResponse?, Error?) -> Void

// URLSession 추상 타입 생성
protocol URLSessionProtocol {
    func dataTask(with urlReqeust: URLRequest, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTaskProtocol
}

// URLSession이 추상 타입에 포함될 수 있도록 프로토콜 채택
extension URLSession: URLSessionProtocol {
    func dataTask(with urlReqeust: URLRequest, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTaskProtocol {
        return dataTask(with: urlReqeust, completionHandler: completionHandler) as URLSessionDataTask
    }
}

// URLSessionDataTask 추상 타입 생성
protocol URLSessionDataTaskProtocol {
    func resume()
}

// URLSessionDataTask가 추상 타입에 포함될 수 있도록 프로토콜 채택
extension URLSessionDataTask: URLSessionDataTaskProtocol {}
```

## APIService

```swift
final class APIService {
    // 추상화해서 진짜일 때는 네트워크 통신, 테스트도 하기 위해 Protocol을 가짐
    var urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    // 생략
}
```

- test환경에서 URLSession을 주입받을 수 있도록 저장속성 및 초기화 메서드 구현
- 의존성
    - 서로 다른 객체 사이에 의존 관계가 있다는 것
    - 의존하는 객체가 수정되면 다른 객체도 영향을 받는다.
    - 여기서는 기존에 `URLSession.shared`이기 때문에 해당 객체가 수정되서 영향 받을 일은 없다고 생각한다.
- 의존성 주입
    - 외부에서 객체를 생성해서 넣는 것
    - Unit Test에 용이하다.
    - 객체 간의 의존성을 줄일 수 있다.
- DIP (Dependency Inversion Principle)
    - 구체적인 객체는 추상화된 객체에 의존해야 한다.
    - Swift에서 추상적인 객체는 Protocol이 있다.
    - 현재 `APIService`는 추상적인 객체 `URLSessionProtocol`에 의존하고 있다.
    - 이렇게 구현하면 `URLSessionProtocol`을 채택하는 객체를 만들어서 주입해주면 된다.

## MockURLSession, MockURLSessionDataTask

```swift
final class MockURLSession: URLSessionProtocol {
    let dummyData: Data
    let url = URL(string: "https://test.com")!
    
    var condition: APIError?
    
    init() {
        let path = Bundle.main.path(forResource: "content", ofType: "json")!
        let jsonString = try! String(contentsOfFile: path)
        dummyData = jsonString.data(using: .utf8)!
    }
    
    // 우리가 원하는 상황에 대한 정보를 Completion으로 넘겨야하는지 미리 정의
    private func makeResultValues(of condition: APIError?) -> (Data?, HTTPURLResponse?, APIError?) {
        switch condition {
        case .sessionError:
            return (nil, nil, .sessionError)
        case .responseIsNil:
            return (nil, nil, nil)
        case .unexpectedResponse:
            return (nil, HTTPURLResponse(url: url, statusCode: 300, httpVersion: "2", headerFields: nil), nil)
        case .unexpectedData:
            return (nil, HTTPURLResponse(url: url, statusCode: 200, httpVersion: "2", headerFields: nil), nil)
        case .status_200:
            return (dummyData, HTTPURLResponse(url: url, statusCode: 200, httpVersion: "2", headerFields: nil), nil)
        case .status_400:
            return (nil, HTTPURLResponse(url: url, statusCode: 404, httpVersion: "2", headerFields: nil), nil)
        case .status_500:
            return (nil, HTTPURLResponse(url: url, statusCode: 501, httpVersion: "2", headerFields: nil), nil)
        default:
            return (nil, nil, nil)
        }
    }
    
    // dataTask가 불리면 미리 정의된 정보를 resumeDidCall에서 호출
    func dataTask(
        with urlReqeust: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    -> URLSessionDataTaskProtocol {
        let dataTask = MockURLSessionDataTask()
        dataTask.resumDidCall = {
            let resultValue = self.makeResultValues(of: self.condition)
            completionHandler(resultValue.0, resultValue.1, resultValue.2)
        }
        return dataTask
    }
}

final class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    var resumDidCall: () -> Void = {}
    
    func resume() {
        resumDidCall()
    }
}
```

## 테스트 코드

[APIServiceTests.swift](https://github.com/hhhan0315/Unsplash/blob/main/UnsplashTests/Network/APIServiceTests.swift)

<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/networkTest.png">
