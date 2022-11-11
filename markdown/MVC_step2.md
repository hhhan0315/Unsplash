# 2. DataSource, Delegate 분리
- UICollectionView의 DataSource와 Delegate 부분을 분리시킴으로써 재사용할 수 있었다.

```swift
protocol PhotoListViewActionListener: AnyObject {
    func photoListViewWillDisplayLast()
    func photoListViewCellDidTap(with photo: Photo)
}

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
    
    // MARK: - Private Properties
    
    private let dataSource = PhotoListDataSource()
    private let delegate = PhotoListDeleagte()
    
    // MARK: - Internal Properties
    
    weak var listener: PhotoListViewActionListener?
    
    var photos: [Photo] = [] {
        didSet {
            dataSource.photos = photos
            delegate.photos = photos
            
            DispatchQueue.main.async {
                self.photoCollectionView.reloadData()
            }
        }
    }
    
    // MARK: - View LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        photoCollectionView.dataSource = dataSource
        photoCollectionView.delegate = delegate
        
        setupPhotoCollectionView()
        bindAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setupPhotoCollectionView() {
        addSubview(photoCollectionView)
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: topAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    // MARK: - User Action
    
    private func bindAction() {
        delegate.willDisplayClosure = { [weak self] in
            self?.listener?.photoListViewWillDisplayLast()
        }

        delegate.selectPhotoClosure = { [weak self] selectedPhoto in
            self?.listener?.photoListViewCellDidTap(with: selectedPhoto)
        }
    }
}
```

```swift
// 기존의 DataSource 코드와 동일하다.
final class PhotoListDataSource: NSObject, UICollectionViewDataSource {
    var photos: [Photo] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return .init()
        }
        let photo = self.photos[indexPath.item]
        cell.photo = photo
        return cell
    }
}
```

```swift
// 기존의 Delegate 코드와 동일하다.
final class PhotoListDeleagte: NSObject, UICollectionViewDelegateFlowLayout {
    var photos: [Photo] = []
    var willDisplayClosure: (() -> Void)?
    var didSelectPhotoClosure: ((Photo) -> Void)?
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == photos.count - 1 {
            willDisplayClosure?()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.item]
        didSelectPhotoClosure?(photo)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = UIScreen.main.bounds.width
        let imageHeight = photos[indexPath.item].height
        let imageWidth = photos[indexPath.item].width
        let imageRatio = imageHeight / imageWidth
        
        return CGSize(width: cellWidth, height: imageRatio * cellWidth)
    }
}
```

## NSObject

- Cocoa Touch Framework
    - UIKit, Foundation, CoreData, MapKit 등을 포함하는 프레임워크
    - iOS, iPadOS Application 개발하기 위한 통합 프레임워크
    - Objective-C Runtime 기반
    - Objective-C 최상위 클래스인 NSObject 상속

- Cocoa Framework
    - AppKit, Foundation, CoreData, MapKit 등을 포함하는 프레임워크
    - MacOS 개발 프레임워크

- Custom DataSource, Delegate를 작성할 때 NSObject를 상속해야 오류가 발생하지 않는다.
- UICollectionViewDataSource는 NSObjectProtocol을 채택하고 있다.
- 그렇기 때문에 해당 프로토콜의 메서드를 직접 구현해야 한다.
- 직접 구현하는 가장 쉬운 방법은 NSObject의 하위 클래스를 만드는 것이다.(= 상속받는 것이다.)

![1](https://github.com/hhhan0315/Unsplash/blob/main/screenshot/MVC_step2_1.png)

## Deleagte? Closure?
- ViewController -> View 작업 위임을 Delegate로 기존 작업에서 구현
- View -> Delegate 작업 위임을 Delegate? Closure? 선택 가능
- Delegate는 써야할 코드가 많지만 그로 인해 가독성이 더 좋다.
- Closure는 간단해서 쓰기 쉽지만 내용이 많아지면 Delegate와 다르게 복잡해진다.
- 초기에는 Closure를 통해서 작성했지만 커뮤니케이션이 1개일 때는 클로져, 2개 이상일 때는 Delegate를 사용하는 것이 좋아보인다.
- 작업 위임을 Delegate로 작성하기로 했다.

```swift
protocol PhotoListDelegateActionListener: AnyObject {
    func willDisplay()
    func didSelect(with photo: Photo)
}

final class PhotoListDeleagte: NSObject, UICollectionViewDelegateFlowLayout {
    var photos: [Photo] = []
    
    weak var listener: PhotoListDelegateActionListener?
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == photos.count - 1 {
            listener?.willDisplay()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.item]
        listener?.didSelect(with: photo)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = UIScreen.main.bounds.width
        let imageHeight = photos[indexPath.item].height
        let imageWidth = photos[indexPath.item].width
        let imageRatio = imageHeight / imageWidth
        
        return CGSize(width: cellWidth, height: imageRatio * cellWidth)
    }
}
```
