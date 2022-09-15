# Unsplash
Unsplash Image API를 활용한 사진 앱

## Diagram
|Home|Search|
|--|--|
|<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/diagram1.jpg">|<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/diagram2.jpg">|

## 기능
|Pagination|세부 화면|검색|
|--|--|--|
|<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/pagination.gif" width="220">|<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/detail.gif" width="220">|<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/search.gif" width="220">|

|저장 권한 허용 및 성공|저장 권한 허용 요청|
|--|--|
|<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/save.gif" width="220">|<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/save_failure.gif" width="220">|

## 구조
<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/architecture1.png">
<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/architecture2.png">

> MVVM
- ViewController는 UI 화면 담당
- ViewModel은 데이터 관리 및 비즈니스 로직 담당

## 커밋 메시지
- Convention
  - [feat] : 기능 추가 / 새로운 로직
  - [fix] : 버그 수정
  - [chore] : 간단한 수정
  - [docs] : 문서 및 리드미 작성
  - [refactor] : 리팩토링

## 회고
> 싱글톤을 선택한 이유
- URLSession.shared를 이용해 data를 completion으로 전달해주는 NetworkManager, URL로 이미지 데이터를 가져오는 ImageLoader, 이미지 캐시를 관리해주는 ImageCacheManager에 싱글톤을 구현했었다.
- 싱글톤의 분명한 단점들 중에 쉽게 접근할 수 있는 탓에 프로젝트 어디서든 사용할 수 있고 어떤 객체와 연결되어 있는지 확인하기 힘든 문제가 존재한다는 단점이 눈에 들어왔다.
- 그래서 ImageCacheManager만 싱글톤으로 구현했으며 그 이유는 해당 객체 안에 NSCache라는 메모리 캐시를 활용하는데 사용할 때마다 객체를 생성한다면 캐시가 새롭게 생성되기 때문에 이미지 데이터를 캐시로 불어올 수 없어서 전역 객체를 만들어서 캐시에 언제든 접근할 수 있도록 구현했다.
- 참고 : https://medium.com/hcleedev/swift-singleton-싱글톤-패턴-b84cfe57c541

> Moya 참고해 Network 설계
- Moya 라이브러리 중 TargetType 참고
- `API`
  - https://github.com/hhhan0315/Unsplash/blob/main/Unsplash/Model/API.swift
  - enum 타입으로 구현 및 연관값, 변수에 바인딩해서 주소 분리
- `APICaller`
  - https://github.com/hhhan0315/Unsplash/blob/main/Unsplash/Model/APICaller.swift
  - API 열거형, Generic을 활용해 Decodable한 객체를 completion으로 전달해주는 역할
- 참고 : https://jiseobkim.github.io/swift/2021/08/16/swift-내가-쓰는-Network-Request-스타일(Moya-착안).html

> MVC 패턴
- 객체지향, MVC, MVVM 패턴 등은 모두 코드를 유지보수하기 쉽고 읽기 쉽게 만들기 위한 방법이라고 생각이 들었다.
- 다른 플랫폼의 MVP는 개념적으로는 iOS MVC와 같지만 실제로 UIKit에서의 MVC는 View, ViewController(Controller) 간의 결합이 너무 강하다.
- 그래서 iOS에서 MVP, MVVM을 이야기 할때는 둘 다 공통적으로 ViewController도 View 취급을 하는 것이며 이걸 해결한 것이 위와 같은 패턴들이다.
- 참고
  - https://velog.io/@eddy_song/mvc
  - https://velog.io/@eddy_song/ios-mvc

> Diffable DataSource
- UICollectionView Diffable DataSource 활용
- iOS 13.0 이후부터 가능

> Pinterest Layout
- 참고 : https://linux-studying.tistory.com/23
- 각 이미지의 높이에 알맞게 구성해주기 위해 Pinterest Layout 활용

> UICollectionView Compositional Layout
- iOS 13.0 이후부터 가능
- DetailViewController에서 전체 화면으로 가로 스크롤 구현에 활용
- visibleItemsInvalidationHandler 활용해 각 아이템이 보여지기 전에 컨트롤 가능

> UIImageWriteToSavedPhotosAlbum
- 참고 : https://www.hackingwithswift.com/books/ios-swiftui/how-to-save-images-to-the-users-photo-library
- 단순히 앨범에 저장하기 위해 사용
- ImageSaver 클래스를 통해 성공, 실패 확인 가능
- info.plist에 `Privacy - Photo Library Additions Usage Description` 추가
