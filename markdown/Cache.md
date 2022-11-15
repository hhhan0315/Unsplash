# 이미지 캐시 구현
## Cache
- 데이터나 값을 미리 복사해 놓는 임시 장소
- 한번 불러온 이미지가 있을 경우 빠른 속도로 미리 저장해둔 장소에서 가져올 수 있다.

## NSCache
- 인메모리 캐싱 바식
- 리소스가 부족할 때 제거될 임시 키와 값으로 저장되는 변경가능한 컬렉션
- 계산 및 비용이 많이 드는 데이터가 있는 객체를 NSCache를 통해 임시 저장한다.

## URLCache
- 인메모리, 디스크 방식이 모두 가능한 캐싱 방식
- URL 요청으로 인한 응답 캐싱을 구현

## 구현
- 기존에는 NSCache로 구현했지만 설명을 읽어보니까 현재 프로젝트 네트워크 요청 후 이미지 응답 객체들을 받아오는데 URLCache로 구현하는 것이 좀 더 올바르지 않을까해서 URLCache를 선택
- 또한 온디스크 방식을 지원하기 때문에 이미지 같이 큰 파일에 적합할거라고 예상
- `print(URLCache.shared.currentDiskUsage, URLCache.shared.currentMemoryUsage)` 해당 함수로 확인해보니까 기본적으로는 URLCache의 디스크 사용량이 증가했다.

```swift
final class ImageCacheManager {
    let cache = URLCache.shared
    
    func getImage(imageURL: URL, completion: @escaping (Data) -> Void) {
        let request = URLRequest(url: imageURL)
        
        if self.cache.cachedResponse(for: request) == nil {
            downloadImage(imageURL: imageURL) { data in
                completion(data)
            }
        } else {
            loadFromCache(imageURL: imageURL) { data in
                completion(data)
            }
        }
    }
    
    private func downloadImage(imageURL: URL, completion: @escaping (Data) -> Void) {
        let request = URLRequest(url: imageURL)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response else {
                return
            }
            
            let cachedData = CachedURLResponse(response: response, data: data)
            self.cache.storeCachedResponse(cachedData, for: request)
            completion(data)
        }.resume()
    }
    
    private func loadFromCache(imageURL: URL, completion: @escaping (Data) -> Void) {
        let request = URLRequest(url: imageURL)
        
        if let data = self.cache.cachedResponse(for: request)?.data {
            completion(data)
        }
    }
}
```

```swift
extension UIImageView {
    func downloadImage(with photo: Photo?) {
        guard let urlString = photo?.urls.regular else {
            return
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        ImageCacheManager().getImage(imageURL: url) { data in
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
    }
}
```
