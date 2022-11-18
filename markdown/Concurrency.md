# 동시성 프로그래밍

## 공부 이유

- UI 관련 메서드 동작은 `DispatchQueue.main.async`에서 동작해야 오류가 발생하지 않는다.
- `DispatchQueue.main.sync`도 있는데 왜 async만 동작하는걸까? 라는 생각으로 정리해보고자 한다.

## 동시성

- 앱 실행 시 메인 스레드에는 Main Run Loop중이다.
- 아이폰이 60Hz라면 1초에 60번 화면을 그리고 있다는 뜻이며 만약 네트워크를 통한 데이터 로딩 같은 무거운 작업을 실행하는 경우 앱의 화면이 느려지거나 멈춰보이게 된다.
- 그래서 오래 걸리는 작업을 어떻게 분산처리할 것인가에 대해 공부하게 된다.

<br>

- iOS에서는 대기 큐에 보내기만 하면 알아서 분산처리해준다.
- 이게 우리가 사용하는 `DispatchQueue`다. (GCD : Grand Central DispatchQueue)

## 병렬 vs 동시성

- 병렬 : 물리적인 쓰레드에서 동시에 일을 하는 개념
- 동시성 : 메인 쓰레드가 아닌 다른 소프트웨어적인 쓰레드에서 동시에 일을 하는 개념 (개발자는 여기에 신경 씀)

## Sync, Async

- sync : `결과값`을 기다리고 실행
- async : `결과값`을 기다리지 않고 실행

## Blocking, Non-Blocking

- Blocking : `CPU 제어권` 바로 반환하지 않음
- Non-Blocking : `CPU 제어권` 바로 반환

- sync & blocking
- async & non-blocking

## 직렬, 동시

- Serial : 분산처리 작업을 한개의 쓰레드에서 처리
    - DispatchQueue.main
- Concurrent : 분산처리 작업을 다른 여러개의 쓰레드에서 처리
    - DispatchQueue.global
- DispatchQueue(label: "") : 커스텀
    - 기본은 Serial, 설정으로 Concurrent도 가능
    
## UI는 왜 메인스레드에서 업데이트?

- Main Run Loop가 View Drawing Cycle을 관리하는데 여러 개의 스레드에서 동작한다면 뷰가 올바르지 않게 동작할 수 있다.
- 그래서 대부분 다른 운영체제에서도 UI 업데이트는 메인스레드에서 이루어지도록 구현되어 있다.

## 그럼 왜 main.sync는 불가능?

- [참고 : 후랑노트 - DispatchQueue.main.sync에 대해](https://furang-note.tistory.com/38)
- Main 큐는 특수한 큐이기 때문에 현재의 runloop가 끝난 후에 Main 큐에 담긴 task들이 실행된다.
- 그래서 우리가 main.async를 사용하면 Main 큐에 task를 추가하고 즉시 반환에서 문제되지 않는다.
- 하지만 main.sync를 사용하면 Main 큐에 task를 추가하고 해당 task가 종료될 때까지 기다린 후 반환되는데 Main 큐는 runloop가 끝나고 task들이 실행되는데 task를 실행할 수 없어서 오류가 발생한다.
