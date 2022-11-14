# Unsplash
Unsplash Image API를 활용한 사진 앱

Unsplash unofficial app for iOS

> Network - Secrets - clientID에 Unsplash API Key 입력 후 실행

> iOS 14.0

## 구현 내용
- MVC 해체
    - [1. View, Layout Constraint 분리 및 User Action 처리](https://github.com/hhhan0315/Unsplash/tree/main/markdown/MVC_step1.md)
        - `loadView` `Delegate 패턴` `필수 생성자`
    - [2. DataSource, Delegate 분리](https://github.com/hhhan0315/Unsplash/tree/main/markdown/MVC_step2.md)
        - `NSObject` `Delegate or Closure` 
    - [3. 네트워크, 코어데이터 로직 분리](https://github.com/hhhan0315/Unsplash/tree/main/markdown/MVC_step3.md)
        - `weak self` `enum` `Generic` `Result Type` `CoreData` `Singleton`
    - [[참고] let us: Go! 2022 여름 - Ever님 / 주니어 입장에서 바라보는 디자인패턴 & 아키텍처](https://www.youtube.com/watch?v=-GzZ0Yj8h1g&t=705s)
- [사진 Pagination 구현 방법]
- [Mock을 이용한 Network Unit Test]
- [사진 캐시 구현]

- [MVVM 패턴](https://github.com/hhhan0315/Unsplash/tree/main/markdown/MVVM.md)
- [네트워크 객체](https://github.com/hhhan0315/Unsplash/tree/main/markdown/Network.md)
- [Combine 메모리 해제](https://github.com/hhhan0315/Unsplash/tree/main/markdown/Combine_Memory_Leak.md)
- [ImageCacheManager 싱글톤 선택 이유](https://github.com/hhhan0315/Unsplash/tree/main/markdown/Singleton.md)
- [UITableView, UICollectionView reloadData 시 깜빡거림 해결](https://github.com/hhhan0315/Unsplash/tree/main/markdown/Flicker_Reload.md)
- [DetailViewController 다양한 기능들](https://github.com/hhhan0315/Unsplash/tree/main/markdown/DetailViewController.md)

## 스크린샷

<p>
  <img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/intro_home.png" width="30%"/>
  <img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/intro_topic.png" width="30%"/>
  <img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/intro_topic_photo.png" width="30%"/>
  <img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/intro_search.png" width="30%"/>
  <img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/intro_like.png" width="30%"/>
  <img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/intro_like_detail.png" width="30%"/>
</p>

## 기능

### 사진 리스트 화면(홈)
||
|--|
|<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/feature_home.gif"/>|
|- Unsplash API 중 List photos 활용 <br> - Pagination 구현|

### 검색 화면
|||
|--|--|
|<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/feature_topic.gif"/>|<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/feature_search.gif"/>|
|- Unsplash API 중 List topics 활용해 초기화면 구현 <br> - Topic 클릭 시 해당 Topic 사진들을 보여준다.|- SearchBar를 활용해 검색할 수 있고 검색 결과를 보여준다.|

### 사진 상세 화면
||
|--|
|<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/feature_detail.gif"/>|
|- 좋아요 기능 <br> - 앨범에 사진 저장 기능 <br> - [DetailViewController 다양한 기능들](https://github.com/hhhan0315/Unsplash/tree/main/markdown/DetailViewController.md)|

### 좋아요 화면
||
|--|
|<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/feature_heart.gif"/>|
|- 좋아요 표시한 사진들을 표시 <br> - CoreData를 활용한 사진 정보 저장|

