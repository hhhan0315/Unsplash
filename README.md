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
- [이미지 Pagination 구현 방법](https://github.com/hhhan0315/Unsplash/tree/main/markdown/Pagination.md)
    - `reloadData` `reloadSections` `Range & insertItems` `UICollectionViewDiffableDataSource`
- [Mock을 이용한 Network Unit Test](https://github.com/hhhan0315/Unsplash/tree/main/markdown/NetworkTest.md)
- [이미지 캐시 구현](https://github.com/hhhan0315/Unsplash/tree/main/markdown/Cache.md)
    - `URLCache`

## 스크린샷

<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/intro.png">

## 기능

### 사진 리스트

<p>
    <img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/intro_home.gif"/>
    <img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/intro_topic.gif"/>
</p>

### 검색
    
<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/intro_search.gif"/>

### 사진 좋아요

<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/intro_heart.gif"/>

- 하트 버튼 클릭하거나 사진 더블 클릭 시 CoreData에 저장 후 애니메이션 동작
