# UITableView, UICollectionView reloadData 시 깜빡거림 해결

# 문제상황
- Infinite Scroll 같이 Pagination 기능을 구현 중에 발생
- 마지막 cell을 보여줄 때 이제 다음 사진들을 요청해서 보여주면서 collectionView.reloadData를 처리
- 이때 전체 tableView가 깜빡거리는 현상이 있다.(gif파일로 저장해서 보여주려고 했지만 잘 나타나지 않음)

```swift
viewModel.$photos
    .receive(on: DispatchQueue.main)
    .sink { [weak self] photos in
        self?.photoTableView.reloadData()
    }
    .store(in: &cancellable)
```

# 해결방법 1
- ViewModel을 활용해 Range<Int>를 활용

```swift
private func setupBind() {
    viewModel.$range
        .receive(on: DispatchQueue.main)
        .sink { range in
            guard let range = range else {
                return
            }
            let indexPaths = range.map { IndexPath(row: $0, section: TableSection.photos.rawValue) }
            self.photoTableView.insertRows(at: indexPaths, with: .none)
        }
        .store(in: &cancellable)
}

final class HomeViewModel {
    @Published var range: Range<Int>? = nil
    
    private var photos: [Photo] = []
    
    func fetch() {
        let count = self.photosCount()
        
        photoService.fetch { result in
            switch result {
            case .success(let photos):
                self.photos.append(contentsOf: photos)
                self.range = count..<count + self.photosCount()
            case .failure(let apiError):
                self.error = apiError
            }
        }
    }
}
```

- 변화된 범위만큼만 저장 후 범위만큼만 애니메이션 동작

# 해결방법 2
- UICollectionViewDiffableDataSource 사용
- UITableView에서 UICollectionView로 변경한 이유는 PinterestLayout을 사용하기 위해서고 중복을 방지하기 위해 모든 뷰를 UICollectionView로 변경
- Unique Identifier로 업데이트 실시
- 이전과 달리 달라진 부분을 자동으로 알아차리고 새로운 부분만 다시 그려준다.
- 참고
    - https://zeddios.tistory.com/1197
    - https://velog.io/@ellyheetov/UI-Diffable-Data-Source

```swift
private lazy var photoCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
    collectionView.dataSource = photoDataSource
    collectionView.delegate = self
    collectionView.backgroundColor = .systemBackground
    return collectionView
}()

private var photoDataSource: UICollectionViewDiffableDataSource<Section, Photo>?

enum Section {
    case photos
}

private func setupPhotoDataSource() {
    photoDataSource = UICollectionViewDiffableDataSource(collectionView: photoCollectionView, cellProvider: { collectionView, indexPath, photo in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return .init()
        }
        cell.configureCell(with: photo)
        return cell
    })
}

private func setupBind() {
    viewModel.$photos
        .receive(on: DispatchQueue.main)
        .sink { [weak self] photos in
            var snapShot = NSDiffableDataSourceSnapshot<Section, Photo>()
            snapShot.appendSections([Section.photos])
            snapShot.appendItems(photos)
            self?.photoDataSource?.apply(snapShot)
        }
        .store(in: &cancellable)
}
```

- 변경한 이후에 훨씬 자연스럽게 동작하는 것을 확인할 수 있었다.
