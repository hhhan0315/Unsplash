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
- loadView -> viewDidLoad -> viewWillAppear -> viewDidAppear -> viewWillDisappear -> viewDidDisappear

![step1_1](https://github.com/hhhan0315/Unsplash/blob/main/screenshot/MVC_step1_1.png)

- 사진 한장씩 height 비율에 맞춰서 보여지는 PhotoListView
- Pinterest PhotoListView
- 정사각형 PhotoListView
- 현재 사용되는 뷰의 종류는 3가지이며 각 뷰들을 UIView를 상속해서 작성해준다.


