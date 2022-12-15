# Unsplash
Unsplash Image API를 활용한 사진 앱

Unsplash unofficial app for iOS

> Network - Secrets - clientID에 Unsplash API Key 입력 후 실행

> iOS 13.0

## 구현 내용
### 1. MVC
- MVC 해체
    - [1. View, Layout Constraint 분리 및 User Action 처리](https://github.com/hhhan0315/Unsplash/tree/main/markdown/MVC_step1.md)
        - `loadView` `Delegate 패턴` `필수 생성자`
    - [2. DataSource, Delegate 분리](https://github.com/hhhan0315/Unsplash/tree/main/markdown/MVC_step2.md)
        - `NSObject` `Delegate or Closure` 
    - [3. 네트워크, 코어데이터 로직 분리](https://github.com/hhhan0315/Unsplash/tree/main/markdown/MVC_step3.md)
        - `weak self` `enum` `Generic` `Result Type` `CoreData` `Singleton`
- [이미지 Pagination 구현 방법](https://github.com/hhhan0315/Unsplash/tree/main/markdown/Pagination.md)
    - `reloadData` `reloadSections` `Range & insertItems` `UICollectionViewDiffableDataSource`
- [이미지 캐시 구현](https://github.com/hhhan0315/Unsplash/tree/main/markdown/Cache.md)
    - `URLCache`
- [Mock을 이용한 Network Unit Test](https://github.com/hhhan0315/Unsplash/tree/main/markdown/NetworkTest.md)
    - `의존성 역전` `MockURLSession` `MockURLSessionDataTask` `추상화`
- [동시성 프로그래밍](https://github.com/hhhan0315/Unsplash/tree/main/markdown/Concurrency.md)
    - `sync & async` `blocking & non-blocking` `serial & concurrent`
    
### 2. MVVM
- [Repository pattern](https://github.com/hhhan0315/Unsplash/tree/main/markdown/Repository.md)

## 스크린샷

<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/intro.png">

## 기능

### 사진 리스트
- 사진 리스트를 받아서 스크롤할 수 있습니다.
- 스크롤이 마지막에 도착하면 다음 사진 리스트를 받아올 수 있습니다.

<p>
    <img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/intro_list1.gif"/>
    <img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/intro_list2.gif"/>
</p>

### 검색
- 사진을 검색할 수 있습니다.

<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/intro_search.gif"/>

### 사진 상세 정보
- 좌우로 스크롤하면서 사진을 넘길 수 있습니다.
- 해당 사진을 저장했는지 여부를 확인할 수 있습니다.

<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/intro_detail.gif"/>

### 사진 좋아요
- 하트 버튼을 눌러서 사진 정보를 저장할 수 있습니다.

<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/intro_heart.gif"/>

### 사진 앨범 저장
- 저장 버튼을 눌러서 앨범에 사진을 저장할 수 있습니다.

<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/intro_save.gif"/>

### 사진 정보 공유
- 공유 버튼을 눌러서 사진 웹 주소 정보를 공유할 수 있습니다.

<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/intro_share.gif"/>

## 구조

<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/architecture.png" width="90%"/>

```
├── Unsplash
│   ├── Application
│   │   ├── AppDelegate.swift
│   │   └── SceneDelegate.swift
│   ├── Common
│   │   ├── Alert.swift
│   │   ├── Constants.swift
│   │   ├── CoreDataManager.swift
│   │   ├── Extension
│   │   │   ├── NotificationName+Extension.swift
│   │   │   ├── UIImageView+Extension.swift
│   │   │   └── UIViewController+Extension.swift
│   │   ├── ImageCacheManager.swift
│   │   └── Model
│   │       ├── Photo.swift
│   │       ├── PhotoData+CoreDataClass.swift
│   │       ├── Search.swift
│   │       └── Topic.swift
│   ├── Network
│   │   ├── API.swift
│   │   ├── APIError.swift
│   │   ├── APIService.swift
│   │   ├── Secrets.swift
│   │   ├── URLSessionDataTaskProtocol.swift
│   │   └── URLSessionProtocol.swift
│   ├── Resource
│   │   ├── Assets.xcassets
│   │   │   ├── AccentColor.colorset
│   │   │   │   └── Contents.json
│   │   │   ├── AppIcon.appiconset
│   │   │   │   └── Contents.json
│   │   │   └── Contents.json
│   │   ├── Base.lproj
│   │   │   └── LaunchScreen.storyboard
│   │   ├── Info.plist
│   │   └── Unsplash.xcdatamodeld
│   │       └── Unsplash.xcdatamodel
│   │           └── contents
│   └── Scene
│       ├── Common
│       │   ├── Cells
│       │   │   └── PhotoCollectionViewCell.swift
│       │   └── Views
│       │       ├── BlackGradientImageView.swift
│       │       ├── PhotoListDelegate.swift
│       │       ├── PinterestLayout.swift
│       │       └── PinterestPhotoListView.swift
│       ├── LikesPhotoList
│       │   ├── LikesPhotoCollectionViewCell.swift
│       │   ├── LikesPhotoListView.swift
│       │   └── LikesPhotoListViewController.swift
│       ├── MainTabBarController.swift
│       ├── PhotoDetail
│       │   ├── PhotoDetailView.swift
│       │   └── PhotoDetailViewController.swift
│       ├── PhotoList
│       │   ├── PhotoListView.swift
│       │   └── PhotoListViewController.swift
│       └── Search
│           ├── SearchResult
│           │   └── SearchResultViewController.swift
│           ├── TopicList
│           │   ├── TopicListCollectionViewCell.swift
│           │   ├── TopicListDelegate.swift
│           │   ├── TopicListView.swift
│           │   └── TopicListViewController.swift
│           └── TopicPhotoList
│               └── TopicPhotoListViewController.swift
├── UnsplashTests
│   └── Network
│       ├── APIServiceTests.swift
│       ├── MockURLSession.swift
│       ├── MockURLSessionDataTask.swift
│       └── content.json

```
