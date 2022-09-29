# Unsplash
Unsplash Image API를 활용한 사진 앱

Unsplash unofficial app for iOS

> Network - Secrets - clientID에 Unsplash API Key 입력 후 실행

> iOS 13.0

<p>
  <img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/intro_home.png" width="30%"/>
  <img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/intro_topic.png" width="30%"/>
  <img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/intro_topic_photo.png" width="30%"/>
  <img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/intro_search.png" width="30%"/>
  <img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/intro_like.png" width="30%"/>
  <img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/intro_like_detail.png" width="30%"/>
</p>

## 구현 내용
- [MVVM 패턴](https://github.com/hhhan0315/Unsplash/tree/main/markdown/MVVM.md)
- [네트워크 객체](https://github.com/hhhan0315/Unsplash/tree/main/markdown/Network.md)
- [Combine 메모리 해제](https://github.com/hhhan0315/Unsplash/tree/main/markdown/Combine_Memory_Leak.md)
- [ImageCacheManager 싱글톤 선택 이유](https://github.com/hhhan0315/Unsplash/tree/main/markdown/Singleton.md)
- [UITableView, UICollectionView reloadData 시 깜빡거림 해결](https://github.com/hhhan0315/Unsplash/tree/main/markdown/Flicker_Reload.md)
- [DetailViewController 다양한 기능들](https://github.com/hhhan0315/Unsplash/tree/main/markdown/DetailViewController.md)

## 기능

### 사진 리스트 화면(홈)
- Unsplash API 중 List photos 활용
- Pagination 구현

<p>
  <img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/feature_home.gif" width="25%"/>
</p>

### 검색 화면
- Unsplash API 중 List topics 활용해 초기화면 구현
- Topic 클릭 시 해당 Topic 사진들을 보여준다.

<p>
  <img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/feature_topic.gif" width="25%"/>
</p>

- SearchBar를 활용해 검색할 수 있고 검색 결과를 보여준다.

<p>
  <img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/feature_search.gif" width="25%"/>
</p>

### 사진 상세 화면
- 좋아요 기능
- 앨범에 사진 저장 기능
- UITapGesutre, UIPanGesture, UIScrollView를 활용해 다양한 제스처 기능
- [DetailViewController 다양한 기능들](https://github.com/hhhan0315/Unsplash/tree/main/markdown/DetailViewController.md)

<p>
  <img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/feature_detail.gif" width="25%"/>
</p>

### 좋아요 화면
- 좋아요 표시한 사진들을 보여준다.
- CoreData를 활용한 사진 정보 저장
- FileManager를 활용한 사진 저장 및 불러오기

<p>
  <img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/feature_heart.gif" width="25%"/>
</p>
