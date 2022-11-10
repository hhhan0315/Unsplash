# MVC 해체
- 기존에 Unsplash 사진 앱을 구현할 때 다양한 방법으로 구현해봤다.
- MVC 패턴, 클로저를 활용한 MVVM 패턴, Combine을 활용한 MVVM 패턴, RxSwift를 활용한 Input Output 구현
- 채용 공고에도 그렇고 많이 권장하는 부분이라는 생각이 들어서 공부하고 익혀나갔다.
- 하지만 근본적으로 패턴을 왜 사용해야 하는지에 대한 고민이 부족하다는 생각이 들었고 그 이유 중에 MVC 중에 ViewController가 많은 역할을 하고 있기 때문에 해당 역할들을 분리해주는 방법이 패턴을 사용하는 것이라는 생각이 들었다.
- 처음부터 돌아가서 MVC 패턴을 사용하면서 해당 패턴을 새롭게 리팩토링하는 방법을 생각해보기로 했다.

# 1. View, Layout Constraint 분리 및 User Action 처리
## loadView
- view(메인뷰)를 만들어 내는 시점에 한번 호출
- 코드로 뷰 구현 시 교체 가능 시점
- Interface Builder로 View Controller로 생성하는 경우 해당 메서드를 override하지 말아야 한다.
- 커스텀 구현 시 super를 호출해서는 안된다.
- 공통적인 UI 부분을 해당 메서드로 교체해주려고 사용했다.

![step1_1](https://github.com/hhhan0315/Unsplash/blob/main/screenshot/MVC_step1_1.png)

- 사진 한장씩 height 비율에 맞춰서 보여지는 CollectionView가 존재하는 PhotoListView
- Pinterest PhotoListView
- UICollectionViewCompositionalLayout를 사용한 TopicListView
- 사진 한장만을 보여주고 Label, Button이 존재하는 PhotoDetailView
- 현재 사용되는 뷰의 종류는 4가지이며 중복으로 PhotoListView, PinterestPhotoListView를 사용한다.

- 해당 메서드를 사용함으로써 ViewController에서 UI 구현 부분을 분리할 수 있다.
- 결국 ViewController는 View Life Cycle과 네트워크 비즈니스 로직을 담당하고 있다.

## User Action
- Delegate 패턴을 활용해 객체와 객체 간의 의사소통 구현
- 프로토콜 타입을 통해서 동작을 전달
- 기능
    - collectionViewCell 클릭 시 화면 전환
    - 마지막 cell에 도착할 경우 네트워크 통신을 통해 새로운 사진 불러오기

## 코드
- PhotoListView, PhotoListViewController
```swift

// 프로토콜 활용해 행동 정의
// 약한 참조를 위해서 클래스 전용이어야 한다.
// reference count를 관리하는 것은 클래스이기 때문이다.
// AnyObject를 통해 클래스에만 사용할 것이라는 것을 나타낸다.
// AnyObject : class type의 instance
protocol PhotoListViewActionListener: AnyObject {
    func willDisplayLastPhoto()
    func photoCollectionViewCellDidTap(with photo: Photo)
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
        
    // MARK: - Internal Properties
    
    // reference cycle을 피하기 위해 약한 참조
    weak var listener: PhotoListViewActionListener?
    
    var photos: [Photo] = [] {
        didSet {            
            DispatchQueue.main.async {
                self.photoCollectionView.reloadData()
            }
        }
    }
    
    // MARK: - View LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        
        setupPhotoCollectionView()
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
}

extension PhotoListView: UICollectionViewDataSource {
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

extension PhotoListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == photos.count - 1 {
            // 이벤트 발생 -> 대리자의 메서드 실행
            listener?.willDisplayLastPhoto()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.item]
        // 이벤트 발생 -> 대리자의 메서드 실행
        listener?.photoCollectionViewCellDidTap(with: photo)
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

```swift
final class PhotoListViewController: UIViewController {
    
    // MARK: - View Define
    
    private let mainView = PhotoListView()
    
    // MARK: - Private Properties
    
    private let apiService = APIService()
    
    // MARK: - Internal Properties
    
    private var page = 0
    
    // MARK: - View LifeCycle
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 대리자 설정
        mainView.listener = self
        
        navigationItem.title = "Unsplash"
        
        getListPhotos()
    }
    
    // MARK: - Networking
    
    private func getListPhotos() {
        page += 1
        
        apiService.request(api: .getListPhotos(page: page), dataType: [Photo].self) { [weak self] result in
            switch result {
            case .success(let photos):
                self?.mainView.photos += photos
            case .failure(let apiError):
                DispatchQueue.main.async {
                    self?.showAlert(message: apiError.errorDescription)
                }
            }
        }
    }
}

// MARK: - PhotoListViewActionListener
// 대리자의 메서드를 실행하면 해당 메서드들이 실행
extension PhotoListViewController: PhotoListViewActionListener {
    func willDisplayLastPhoto() {
        getListPhotos()
    }
    
    func photoCollectionViewCellDidTap(with photo: Photo) {
        let photoDetailViewController = PhotoDetailViewController(photo: photo)
        photoDetailViewController.modalPresentationStyle = .overFullScreen
        present(photoDetailViewController, animated: true)
    }
}
```
