# Unsplash
Unsplash Image API를 활용한 사진 앱
> Network - Secrets - clientID에 Unsplash API Key 입력 후 실행

## Screenshot

## 구현 내용
- [MVVM 패턴](https://github.com/hhhan0315/Unsplash/tree/main/markdown/MVVM.md)
- [네트워크 객체](https://github.com/hhhan0315/Unsplash/tree/main/markdown/Network.md)

## 기능

## 회고
> 싱글톤을 선택한 이유
- URLSession.shared를 이용해 data를 completion으로 전달해주는 NetworkManager, URL로 이미지 데이터를 가져오는 ImageLoader, 이미지 캐시를 관리해주는 ImageCacheManager에 싱글톤을 구현했었다.
- 싱글톤의 분명한 단점들 중에 쉽게 접근할 수 있는 탓에 프로젝트 어디서든 사용할 수 있고 어떤 객체와 연결되어 있는지 확인하기 힘든 문제가 존재한다는 단점이 눈에 들어왔다.
- 그래서 ImageCacheManager만 싱글톤으로 구현했으며 그 이유는 해당 객체 안에 NSCache라는 메모리 캐시를 활용하는데 사용할 때마다 객체를 생성한다면 캐시가 새롭게 생성되기 때문에 이미지 데이터를 캐시로 불어올 수 없어서 전역 객체를 만들어서 캐시에 언제든 접근할 수 있도록 구현했다.
- 참고 : https://medium.com/hcleedev/swift-singleton-싱글톤-패턴-b84cfe57c541

> Pinterest Layout
- 참고 : https://linux-studying.tistory.com/23

> UIImageWriteToSavedPhotosAlbum
- 참고 : https://www.hackingwithswift.com/books/ios-swiftui/how-to-save-images-to-the-users-photo-library
- 단순히 앨범에 저장하기 위해 사용
- ImageSaver 클래스를 통해 성공, 실패 확인 가능
- info.plist에 `Privacy - Photo Library Additions Usage Description` 추가
