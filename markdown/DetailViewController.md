# DetailViewController 다양한 기능들

## ScrollView를 활용한 ImageView zoom 기능
- UIScrollView 안에 UIImageView를 넣는 것이 핵심
- 참고 : https://fomaios.tistory.com/entry/iOS-이미지-줌으로-확대축소하기feat-스크롤뷰

<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/detail_zoom.gif" width="25%"/>

## 좋아요 기능
- DetailViewModel에서 CoreData, FileManager 관련 메서드 동작
- FileManager에 좋아요한 사진 확인 가능
  - info.plist에 `Supports Document Browser` 값 `YES` 선언
- isHeartSelected 변수를 이용해 UI 변경
- 해당 변수가 변경되면 NotificationCenter로 알려서 HeartViewController fetch 실행

<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/detail_heart.gif" width="25%"/>

## 앨범 사진 저장 기능
- UIImageWriteToSavedPhotosAlbum
- 단순히 앨범에 저장하기 위해 사용
- ImageSaver 클래스를 통해 성공, 실패 확인 가능
- info.plist에 `Privacy - Photo Library Additions Usage Description` 추가
- 참고 : https://www.hackingwithswift.com/books/ios-swiftui/how-to-save-images-to-the-users-photo-library

<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/detail_save.gif" width="25%"/>

## UITapGesutre
### Single Tap
- Double Tap이 동작하지 않았을 때 실행

<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/detail_tap.gif" width="25%"/>

### Double Tap
- numberOfTapsRequired = 2 선언

<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/detail_tap_double.gif" width="25%"/>

## UIPanGesture
- 해당 뷰를 아래, 왼쪽, 오른쪽으로 이동시키면 dismiss

<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/detail_dismiss.gif" width="25%"/>
