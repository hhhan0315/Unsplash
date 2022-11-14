# 사진 Pagination 구현
- infinte scroll 이라고 불린다.

# 1. reloadData 활용

```swift
protocol PhotoListDelegateActionListener: AnyObject {
    func willDisplayLast()
    func didSelect(with photo: Photo)
}

final class PhotoListDeleagte: NSObject, UICollectionViewDelegateFlowLayout {
    var photos: [Photo] = []
    
    weak var listener: PhotoListDelegateActionListener?
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if photos.count >= Constants.perPage && indexPath.item == photos.count - 1 {
            listener?.willDisplayLast()
        }
    }
    
    // 생략
}
```

- 모두 UICollectionView를 활용하고 있으며 마지막 UICollectionViewDelegate의 `willDisplay` 메서드를 활용해 해당 indexPath의 item이 배열 전체의 마지막과 같다면 네트워크 요청을 처리한다.
- `PhotoListDelegate` -> `PhotoListView` -> `PhotoListViewController`로 Delegate로 위임해서 동작하며 `PhotoListViewController`에서 네트워크 요청 후에 다시 `PhotoListView`의 `photos`에 데이터를 추가해준다.

```swift
var photos: [Photo] = [] {
    didSet {
        dataSource.photos = photos
        delegate.photos = photos
        
        DispatchQueue.main.async {
            self.photoCollectionView.reloadData()
            self.infoLabel.isHidden = self.photos.isEmpty ? false : true
        }
    }
}
```

- reloadData() 실행

<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/pagination_1.gif" width="30%"/>

- 깜빡거리는 현상 발생

# 2. reloadSections 활용
