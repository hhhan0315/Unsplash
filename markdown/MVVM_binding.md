# MVVM 1:N 바인딩
- 이건 현재 프로젝트에서는 코드가 존재하지 않지만 구현에 성공해서 적어두려고 한다.

# 구현해보고 싶었던 기능
- Detail 화면에서 마지막 사진에 도착하면 다음 사진을 로딩하고 싶었다.
- 다시 돌아가도 사진이 똑같이 존재했으면 좋겠다고 생각했다.

<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/mvvm_binding1.gif" width="25%"/>

# MVVM 선택 이유 중 하나
- MVC로 구현해보려고 하니까 좋은 방법이 떠오르지 않았다.
- MVVM을 구현해보니까 우리가 사용하는 데이터는 ViewModel에 존재한다는 것을 알았고 View는 내가 원하는 방법으로 여러가지로 구현하고 ViewModel만 사용하면 된다는 것을 알았다.
- 예시로 PhotoListViewController, PhotoDetailViewController에서 동일하게 PhotoListViewModel을 구독하면 해결할 수 있었다.

<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/mvvm_binding2.gif" width="25%"/>

- 그러면 PhotoListViewController도 동일하게 구독하고 있기 때문에 변화가 일어난다.
