# Repository pattern
- 참고 : [devming - Repository Pattern에 대해서](https://devming.medium.com/repository-pattern에-대해서-255731577927)

# 선택 이유
- 현재 프로젝트는 사진에 대한 정보를 불러옵니다.
- ViewController의 mainView가 직접 이 데이터를 가지고 있었다.

```swift    
private func getListPhotos() {
    page += 1
        
    apiService.request(api: .getListPhotos(page: page), dataType: [Photo].self) { [weak self] result in
        switch result {
        case .success(let photos):
            self?.mainView.photos += photos
        case .failure(let apiError):
            DispatchQueue.main.async {
                self?.showAlert(message: apiError.rawValue)
            }
        }
    }
}
```

- 이렇게 직접 가지고 있다는 것은 나중에 유지보수가 힘들다는 단점이 존재합니다.
- 현재 서버에서 API를 가져오고 있는데 서버에서 구조가 변경된다면 모든 파일들을 모두 수정해줘야합니다.

# Domain, Repository 분리
- 그래서 Clean Architecture의 일부분을 적용해보면서 해결해보려고 합니다.
- Clean Architecture에는 Domain, Data, Presentation으로 분리합니다.
- Domain에서는 앱에서 우리가 보여줘야할 객체를 말하며 우리 앱에서는 사진 객체를 의미합니다.
- Repository를 활용해서 Domain 객체에 Mapping해주면 앱 내부에서 사용하고 있는 객체들을 수정할 필요가 없어진다.

```swift
struct PhotoResponseDTO: Decodable {
    let id: String
    let width: CGFloat
    let height: CGFloat
    let urls: URLDTO
    let user: UserDTO
    
    struct URLDTO: Decodable {
        let raw: String
        let full: String
        let regular: String
        let small: String
        let thumb: String
    }
    
    struct UserDTO: Decodable {
        let name: String
    }
}

extension PhotoResponseDTO {
    func toDomain() -> Photo {
        return .init(
            identifier: UUID(),
            id: id,
            width: width,
            height: height,
            urls: urls.toDomain(),
            user: user.toDomain()
        )
    }
}

extension PhotoResponseDTO.URLDTO {
    func toDomain() -> URLs {
        return .init(regular: regular)
    }
}

extension PhotoResponseDTO.UserDTO {
    func toDomain() -> User {
        return .init(name: name)
    }
}
```

- 위의 코드는 URL를 사용하여 받아오는 데이터를 의미합니다.

```swift
struct Photo {
    let identifier: UUID
    let id: String
    let width: CGFloat
    let height: CGFloat
    let urls: URLs
    let user: User
}
```

- 위의 코드는 우리가 앱에서 사용하는 데이터를 의미합니다.
- 이렇게 분리해줌으로써 우리는 Photo라는 도메인 객체를 사용하는 ViewController에서는 계속 사용을 하면 됩니다.
- 그리고 만약 서버에서 API가 변경되거나 다른 주소를 사용해야 한다면 toDomain() 메서드로 Mapping만 해준다면 Photo라는 도메인 객체를 계속 사용하고 있는 파일에서는 수정해줄 필요가 없습니다.

# 서버가 개발되지 않았을 경우 임시 데이터 사용
- Clean Architecture의 장점을 생각하던 중에 서버에 데이터가 존재하지 않은 경우에도 내가 임의로 데이터를 생성하고 해당 정보를 가지고 앱을 미리 구현해볼 수 있겠다고 생각했다.

```swift
final class MockPhotoRepository: PhotoRepository {
    func fetchPhotoList(page: Int, completion: @escaping (Result<[Photo], NetworkError>) -> Void) {
        var photos: [Photo] = []
        
        (0..<5).forEach { _ in
            let photo = Photo(
                identifier: UUID(),
                id: "4ct0iDMOjuc",
                width: 7360,
                height: 4912,
                urls: URLs(regular: "https://images.unsplash.com/photo-1670871139297-a0fa99ec523d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwzMjQ4MTB8MHwxfGFsbHwyfHx8fHx8Mnx8MTY3MDg5OTUyNQ&ixlib=rb-4.0.3&q=80&w=1080"),
                user: User(name: "UserName"))
            photos.append(photo)
        }
        
        completion(.success(photos))
    }
}
```

- 위의 코드는 PhotoRepository 프로토콜을 채택한 Mock입니다.
- 네트워크를 통해 [Photo]를 리턴해주는 것이 아니라 임의의 데이터를 리턴해줍니다.

```swift
let networkService = NetworkService()
//  let photoRepository = DefaultPhotoRepository(networkService: networkService)
let photoRepository = MockPhotoRepository()
let photoListViewModel = PhotoListViewModel(photoRepository: photoRepository)
let photoListViewController = UINavigationController(rootViewController: PhotoListViewController(viewModel: photoListViewModel))
```

- 위의 코드처럼 의존성 주입만 변경해주면 됩니다.
- PhotoListViewModel가 Repository 인터페이스를 두기 때문에 의존성 역전 원칙을 지킬 수 있습니다.
- 실제 구현은 Data 영역의 Repository가 담당합니다.
- 그래서 네트워크를 사용하거나 사용하지 않고 임의의 데이터를 반환하거나하는 등을 사용할 수 있습니다.

<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/repository.png" width="20%"/>
