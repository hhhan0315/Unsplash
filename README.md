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

## 기능

## 회고
> UIImageWriteToSavedPhotosAlbum
- 참고 : https://www.hackingwithswift.com/books/ios-swiftui/how-to-save-images-to-the-users-photo-library
- 단순히 앨범에 저장하기 위해 사용
- ImageSaver 클래스를 통해 성공, 실패 확인 가능
- info.plist에 `Privacy - Photo Library Additions Usage Description` 추가
