# ImageCacheManager 싱글톤 선택 이유
- URLSession.shared를 이용해 data를 completion으로 전달해주는 NetworkManager, URL로 이미지 데이터를 가져오는 ImageLoader, 이미지 캐시를 관리해주는 ImageCacheManager에 싱글톤을 구현했었다.
- 싱글톤의 분명한 단점들 중에 쉽게 접근할 수 있는 탓에 프로젝트 어디서든 사용할 수 있고 어떤 객체와 연결되어 있는지 확인하기 힘든 문제가 존재한다는 단점이 눈에 들어왔다.
- 최대한 사용하지 않는 방향으로 접근했다.
- 그래서 ImageCacheManager만 싱글톤으로 구현했으며 그 이유는 해당 객체 안에 NSCache라는 메모리 캐시를 활용하는데 사용할 때마다 객체를 생성한다면 캐시가 새롭게 생성되기 때문에 이미지 데이터를 캐시로 불어올 수 없어서 전역 객체를 만들어서 캐시에 언제든 접근할 수 있도록 구현했다.
- 참고 : https://medium.com/hcleedev/swift-singleton-싱글톤-패턴-b84cfe57c541

```swift
final class ImageCacheManager {
    static let shared = ImageCacheManager()
    private init() { }
    
    private var memory = NSCache<NSString, NSData>()
    
    func save(with string: String, data: Data) {
        let key = string as NSString
        self.memory.setObject(NSData(data: data), forKey: key)
    }
    
    func load(with string: String) -> Data? {
        let key = string as NSString
        if let data = self.memory.object(forKey: key) {
            return Data(referencing: data)
        }
        return nil
    }
}
```
