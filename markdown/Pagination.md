# 이미지 Pagination 구현
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

```swift
var photos: [Photo] = [] {
    didSet {
        dataSource.photos = photos
        delegate.photos = photos
        
        DispatchQueue.main.async {
            self.photoCollectionView.reloadSections(IndexSet(integer: 0))
            self.infoLabel.isHidden = self.photos.isEmpty ? false : true
        }
    }
}
```

- reloadData보다 자연스러운 애니메이션 동작

<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/pagination_2.gif" width="30%"/>

# 3. range, insertItems 활용

```swift
    private var range: Range<Int>? = nil
    private var previousPhotosCount = 0
    
    var photos: [Photo] = [] {
        didSet {
            dataSource.photos = photos
            delegate.photos = photos
            
            range = previousPhotosCount..<photos.count
            previousPhotosCount += photos.count
            
            let indexPaths = range?.map { IndexPath(item: $0, section: 0)}
            
            DispatchQueue.main.async {
                self.photoCollectionView.insertItems(at: indexPaths ?? [])
                self.infoLabel.isHidden = self.photos.isEmpty ? false : true
            }
        }
    }
```

- 불려오는 개수만큼 기존의 item은 건들지 않고 insertItems 메서드를 활용할 수 있다.
- 원하는 모습으로 동작한다.

# 4. UICollectionViewDiffableDataSource 활용

```swift
final class PhotoListView: UIView {
    
    // MARK: - View Define
    
    private let photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "No photos"
        return label
    }()
    
    enum Section {
        case photos
    }

    private var dataSource: UICollectionViewDiffableDataSource<Section, Photo>?
    
    // MARK: - Private Properties
    
    private let delegate = PhotoListDeleagte()
        
    // MARK: - Internal Properties
    
    weak var listener: PhotoListViewActionListener?
    
    var photos: [Photo] = [] {
        didSet {
            delegate.photos = photos
            setupSnapShot()
            
            DispatchQueue.main.async {
                self.infoLabel.isHidden = self.photos.isEmpty ? false : true
            }
        }
    }
    
    // MARK: - View LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        photoCollectionView.dataSource = dataSource
        photoCollectionView.delegate = delegate
        
        delegate.listener = self
        
        setupViews()
        setupPhotoDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setupViews() {
        setupPhotoCollectionView()
        setupInfoLabel()
    }
    
    private func setupPhotoCollectionView() {
        addSubview(photoCollectionView)
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func setupInfoLabel() {
        addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    private func setupPhotoDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: photoCollectionView, cellProvider: { collectionView, indexPath, photo in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
                return .init()
            }
            cell.photo = photo
            return cell
        })
    }

    private func setupSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Photo>()
        snapShot.appendSections([Section.photos])
        snapShot.appendItems(self.photos)
        self.dataSource?.apply(snapShot)
    }
}
```

- iOS 13부터 사용 가능하다.
- 기존의 DataSource와는 다르게 달라진 데이터 부분을 추저갛여 자연스럽게 UI를 업데이트한다.
- API 통신 -> 응답 -> UICollectionView reloadData
- 기존의 방식은 데이터의 변경 상황을 수동으로 관리해줘야 한다.(오류가 발생할 가능성)

<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/pagination_3.gif" width="30%"/>

- 프로젝트에서는 UICollectionViewDiffableDataSource를 선택해 구현했다.
