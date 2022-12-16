# MVVM & Clean Architecture 적용 이유
- 참고 : [Saryong Kang - Clean Architecture는 모바일 개발을 어떻게 도와주는가? - (1) 경계선: 계층 나누기](https://medium.com/@justfaceit/clean-architecture는-모바일-개발을-어떻게-도와주는가-1-경계선-계층을-정의해준다-b77496744616)

# 클린 아키텍처
- 내부에 있는 계층이 외부에 있는 계층을 알지 못한다.
- `Presentation` -> `Domain` <- `Data`
- Presentation
    - View
        - UI 화면 표시, 사용자 입력을 담당한다.
        - 화면에 그리는 것이 어떤 의미인지 전혀 알지 못한다.
    - Presenter
        - ViewModel(현재 프로젝트)
        - 플랫폼에 직접적으로 의존하지 않으며 테스트 가능하다.
        - 화면에 그리는 것이 어떤 의미인지 알고 있다.
        - 사용자 입력이 왔을 때 어떤 반응을 하는지 판단한다.
- Domain
    - UseCase
        - 비즈니스 로직
    - Model
        - Entity(현재 프로젝트)
        - 앱의 실질적인 데이터
        - API로부터 얻어지는 외부 데이터와 같을 필요가 없다.
    - Translater
        - Data 계층의 Entity를 Domain의 Model로 변환
        - 현재 프로젝트에서는 DTO의 toDomain()을 통해 구현
- Data
    - Repository
        - 외부 API 호출, DB 접근
        - UseCase가 필요로 하는 데이터 저장, 수정 등의 기능을 제공한다.
        - 현재 프로젝트에서는 Domain에는 Repository 인터페이스, Data에는 Repository가 구현되어 있다.
    - Entity
        - API 요청, 응답을 위한 모델
        - 현재 프로젝트에서는 DTO라는 이름으로 저장하고 Domain의 Translater의 역할도 함수로 구현되어 있다.

# 내가 느낀 것
- 기존의 프로젝트와 다르게 코드 양과 파일이 많아진 것을 확인할 수 있었다.
- 그래서 모두 따라하는 것이 아니라 필요한 부분을 선택해 구현해봤다.

## 뷰와 프레젠터 나누기
- 기존의 MVC 구조에서는 하나의 파일에 모든 역할을 담당하고 있었다.
- MVVM 패턴을 사용하면서 UIViewController는 View의 역할을 하면서 UI의 담당만 하고 ViewModel이 Presenter의 역할을 하면서 앱에서 필요로 하는 데이터를 가지게 할 수 있었다.
- 특히 Input, Output 구조를 선택하면서 ViewModel만 확인했을 때 해당 화면의 입력을 확인하고 그에 따라 어떤 반응을 해야하는지도 쉽게 파악할 수 있었다.
- 그리고 View는 언제든 교체될 수 있게 만들 수 있는 것도 장점으로 느껴진다.

```swift
protocol PhotoListViewModelInput {
    func viewDidLoad()
    func willDisplayLast()
}

protocol PhotoListViewModelOutput {
    var photos: [Photo] { get }
    var errorMessage: String? { get }
}

final class PhotoListViewModel: PhotoListViewModelInput, PhotoListViewModelOutput {
    
    // MARK: - Output
    
    @Published var photos: [Photo] = []
    @Published var errorMessage: String?
}

// MARK: - Input

extension PhotoListViewModel {
    func viewDidLoad() {
        fetchPhotoList()
    }
    
    func willDisplayLast() {
        fetchPhotoList()
    }
}
```

## 데이터 바인딩
- ViewModel의 값이 바뀌면 View에서 구독하고 있다가 알맞게 처리해준다.
- 현재 프로젝트에서는 @Published를 사용해서 구현했다.
- 이전에 RxCocoa를 사용할 때 UI 요소와 바인딩이 편했던 경험이 있었다.
- 라이브러리를 사용하지 않고 구현해보고 싶어서 이번에는 선택하지 않았다.

## UseCase
- Domain 계층의 UseCase는 비즈니스 로직을 담당한다고 한다.
- 해당 블로그 글에서는 외부 사업 부서도 알고 있어야 하는 로직이며 앱의 사용자 상호 작용이 아닌 업무 요구사항을 담고 있다고 한다.
- 현재 프로젝트에서는 Repository에서 사용하던걸 UseCase에서 그대로 똑같이 작성하게 되고 Result의 형태도 동일하다고 느껴서 구현하지 않고 ViewModel에서 그대로 Repository를 사용하는 것으로 구현했다.

## ViewModel Unit Test
- 임시의 데이터를 만들어서 input 형태에 따라 잘 동작하는지 확인할 수 있었다.

```swift
final class PhotoListViewModelTests: XCTestCase {
    private var sut: PhotoListViewModel?
    private let photosMock: [Photo] = [Photo(identifier: UUID(), id: "photo1", width: 200, height: 200, urls: URLs(regular: "test.com"), links: Links(html: "test"), user: User(name: "test"))]
    private var cancellables = Set<AnyCancellable>()
    
    func test_viewDidLoad시_fetchPhotoList_성공하는지() {
        let photoRepositoryMock = PhotoRepositoryMock()
        photoRepositoryMock.photos = self.photosMock
        sut = PhotoListViewModel(photoRepository: photoRepositoryMock)
        
        sut?.viewDidLoad()
        
        XCTAssertEqual(sut?.photos.count, 1)
    }
}
```
