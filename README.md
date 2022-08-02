# Unsplash
Unsplash Image API를 활용한 사진 앱

## Diagram
|Home|Search|
|--|--|
|<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/diagram1.png">|<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/diagram2.png">|

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
  - [Feat] : 기능 추가 / 새로운 로직
  - [Fix] : 버그 수정
  - [Chore] : 간단한 수정
  - [Docs] : 문서 및 리드미 작성
  - [Refactor] : 리팩토링

## 과정
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

> Image Cache
- ImageCacheManager를 통해 캐시 구현
- NSCache 활용
