# Combine 메모리 해제

<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/combine_memory_leak.png">

- SearchViewController -> PinterestDetailViewController로 이동하는 상황

```swift
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let topic = viewModel.topic(at: indexPath.item)
        let pinterestDetailViewController = PinterestDetailViewController(slug: topic.slug, title: topic.title)
        navigationController?.pushViewController(pinterestDetailViewController, animated: true)
    }
}
```

# PinterestDetailViewController deinit 호출 실패
- 다시 SearchViewController로 돌아올 경우에 해당 PinterestDetailViewController가 deinit되지 않는 문제가 발생해서 메모리 상을 확인했을 때 계속 PinterestDetailViewController가 생성되는 것을 확인
- Combine을 활용해 PinterestViewModel의 데이터가 변경되면 UI가 변경되도록 구현했는데 해당 부분에 문제인 것을 인지

## 기존 코드

```swift
private func setupBind() {
    viewModel.$photos
        .receive(on: DispatchQueue.main)
        .sink { photos in
            var snapShot = NSDiffableDataSourceSnapshot<Section, Photo>()
            snapShot.appendSections([Section.photos])
            snapShot.appendItems(photos)
            self.photoDataSource?.apply(snapShot)
        }
        .store(in: &cancellable)
    
    viewModel.$error
        .receive(on: DispatchQueue.main)
        .sink { apiError in
            guard let apiError = apiError else {
                return
            }
            self.showAlert(message: apiError.errorDescription)
        }
        .store(in: &cancellable)
}
```

## 해결방법 1

```swift
override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    cancellable.removeAll()
}
```

- 화면이 사라질 때 AnyCancellable로 선언된 cancellable을 removeAll() 해줌으로써 해결
- Cancellable은 cancel() 메서드 존재
- 하지만 AnyCancellable은 해당 ViewController가 deinit되면 cancel()을 호출하지 않아도 자동으로 모든 리소스를 해제시켜준다는 내용 확인

## 해결방법 2

```swift
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
    
    viewModel.$error
        .receive(on: DispatchQueue.main)
        .sink { [weak self] apiError in
            guard let apiError = apiError else {
                return
            }
            self?.showAlert(message: apiError.errorDescription)
        }
        .store(in: &cancellable)
}
```

- weak self를 활용해 다른 객체에 참조되지 않도록 구현
- deinit이 잘 동작하는 것을 확인
