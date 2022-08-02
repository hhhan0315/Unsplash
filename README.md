# Unsplash
Unsplash Image API를 활용한 사진 앱

## Diagram
|Home|Search|
|--|--|
|<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/diagram1.png">|<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/diagram2.png">|

## 기능
|Pagination|세부 화면|검색|
|--|--|
|<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/pagination.gif" width="220">|<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/detail.gif" width="220">|<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/search.gif" width="220">|

|저장 권한 허용 및 성공|저장 권한 허용 요청|
|<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/save.gif" width="220">|<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/save_failure.gif" width="220">|

## 구조
<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/architecture1.png">
<img src="https://github.com/hhhan0315/Unsplash/blob/main/screenshot/architecture2.png">

> MVVM
- ViewController와 View는 UI 화면 담당
- ViewModel은 데이터 관리 및 비즈니스 로직 담당
> Clean Architecture
- UseCase는 ViewModel의 비즈니스 로직 담당 (여기서는 포토 데이터 갱신)
- Repository는 네트워크 등 외부의 데이터를 가져오는 객체

## 커밋 메시지
- Convention
  - [Feat] : 기능 추가 / 새로운 로직
  - [Fix] : 버그 수정
  - [Chore] : 간단한 수정
  - [Docs] : 문서 및 리드미 작성
  - [Refactor] : 리팩토링

## 진행 과정
> MVVM & Clean Architecture 구조에 대한 이해

- 부스트캠프 멤버쉽 Swift 프로젝트 대부분이 해당 구조를 사용하고 있어서 공부
- https://jeonyeohun.tistory.com/305?category=881841 참고

> Diffable DataSource

- Diffable DataSource 및 Compositional Layout으로 구성으로 초기 구현
- Unsplash 앱 처럼 각 이미지의 크기에 알맞게 dynamic height를 구현을 위한 수정
- UIImage를 변수로 가지고 있는 Photo 모델을 통해 SnapShot 구현으로 해결
- https://ios-development.tistory.com/717 참고

> Pinterest Layout
- https://linux-studying.tistory.com/23 참고
