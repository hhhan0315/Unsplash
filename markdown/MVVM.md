# MVVM 패턴
# 사용한 이유
- 테스트의 용이성
    - View와 Controller가 합쳐진 ViewController에서 ViewController는 View의 역할, ViewModel은 View에 나타날 데이터 담당으로 나눠지기 때문에 테스트하기에 좋아진다.
- ViewController의 분리
    - ViewController에서 모든 구현을 하던것을 분리할 수 있었다.
    - ViewController는 UI 구현만 담당하고 View에 관한 비즈니스 로직은 ViewModel이 가지는 것으로 구현할 수 있었다.

# 내가 구현한 MVVM
<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/mvvm.png">

- 첫 번째 화면 HomeViewController 기준
- View(ViewController)
    - 현재 HomeViewController에서 UI 구성 요소
    - collectionView
    - cells(title, image, width, height)
    - cellViewModel을 활용해 원래 네트워크를 통해 받아온 모델을 한번 다시 가공
    - 바인딩은 클로져를 통해 구현했으며 뷰모델의 변수가 변경되면 클로져가 불린다.
  
    ```swift
    final class HomeViewController: UIViewController {
        private func setupViewModel() {
            viewModel.reloadCollectionViewClosure = { [weak self] in
                DispatchQueue.main.async {
                    var snapShot = NSDiffableDataSourceSnapshot<Section, PhotoCellViewModel>()
                    snapShot.appendSections([Section.photos])
                    snapShot.appendItems(self?.viewModel.cellViewModels ?? [])
                    self?.photoDataSource?.apply(snapShot)
                }
            }
            
            viewModel.showAlertClosure = { [weak self] in
                DispatchQueue.main.async {
                    guard let alertMessage = self?.viewModel.alertMessage else {
                        return
                    }
                    self?.showAlert(message: alertMessage)
                }
            }
            
            viewModel.fetch()
        }
    }
    ```

- ViewModel
  
    ```swift
    final class HomeViewModel {    
        private var photos: [Photo] = []
        private var page = 1
        
        var cellViewModels: [PhotoCellViewModel] = [] {
            didSet {
                reloadCollectionViewClosure?()
            }
        }
        
        var alertMessage: String? {
            didSet {
                showAlertClosure?()
            }
        }
        
        var numberOfCells: Int {
            return cellViewModels.count
        }
        
        var reloadCollectionViewClosure: (() -> Void)?
        var showAlertClosure: (() -> Void)?
        
        func getCellViewModel(indexPath: IndexPath) -> PhotoCellViewModel {
            return cellViewModels[indexPath.item]
        }
    }
    ```

- PhotoCellViewModel
    
    ```swift
    struct PhotoCellViewModel {
        let id: String
        let titleText: String
        let imageURL: String
        let imageWidth: Int
        let imageHeight: Int
    }

    extension PhotoCellViewModel: Hashable {
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
    ```
    
- 참고
    - https://www.youtube.com/watch?v=M58LqynqQHc
