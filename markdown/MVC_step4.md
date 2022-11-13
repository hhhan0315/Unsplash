# 4. Coordinator 패턴 활용
## 선택 계기

```swift
let photoDetailViewController = PhotoDetailViewController(photo: photo)
photoDetailViewController.modalPresentationStyle = .overFullScreen
present(photoDetailViewController, animated: true)
```

- PhotoDetailViewController로 화면 전환하는 메서드가 4개의 ViewController에서 중복으로 사용하고 있다.
- 만약 해당 메서드를 수정하려고 하는 경우 사용한 곳에서 모두 접근해서 수정해야 해서 유지보수에 어려웠다.

## 
