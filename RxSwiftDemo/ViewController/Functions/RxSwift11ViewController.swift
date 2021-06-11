//
//  RxSwift11ViewController.swift
//  RxSwiftDemo
//
//  Created by Kystar's Mac Book Pro on 2021/5/26.
//

import RxSwift
import RxCocoa

/// 结合操作（或者称合并操作）指的是将多个 Observable 序列进行组合，
/// 拼装成一个新的 Observable 序列。
class RxSwift11ViewController: BaseViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        startWith()
//        merge()
//        zip()
//        combineLatest()
//        withLatestFrom()
        switchLatest()
    }
    
    /// 该方法会在 Observable序列开始之前插入一些事件元素。即发出事件消息之前，
    /// 会先发出这些预先插入的事件消息。
    func startWith() {
        Observable.of("2", "3")
            .startWith("A")
            .startWith("B")
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    /// 该方法可以将多个（两个或两个以上的）Observable 序列合并成一个 Observable 序列。
    func merge() {
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<Int>()
         
        Observable.of(subject1, subject2)
            .merge()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
         
        subject1.onNext(20)
        subject1.onNext(40)
        subject1.onNext(60)
        subject2.onNext(1)
        subject1.onNext(80)
        subject1.onNext(100)
        subject2.onNext(1)
    }
    
    
    /// 该方法可以将多个（两个或两个以上的）Observable 序列压缩成
    /// 一个 Observable 序列。而且它会等到每个 Observable 事件一
    /// 一对应地凑齐之后再合并。
    func zip() {
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<String>()
         
        Observable.zip(subject1, subject2) {
            "\($0)\($1)"
            }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
         
        subject1.onNext(1)
        subject2.onNext("A")
        subject1.onNext(2)
        subject2.onNext("B")
        subject2.onNext("C")
        subject2.onNext("D")
        subject1.onNext(3)
        subject1.onNext(4)
        subject1.onNext(5)
    }
    
//    zip 常常用在整合网络请求上。
//    比如我们想同时发送两个请求，只有当两个请求都成功后，再将两者的结
//    果整合起来继续往下处理。这个功能就可以通过 zip 来实现。
//    func zipDemo() {
//        //第一个请求
//        let userRequest: Observable<User> = API.getUser("me")
//
//        //第二个请求
//        let friendsRequest: Observable<Friends> = API.getFriends("me")
//
//        //将两个请求合并处理
//        Observable.zip(userRequest, friendsRequest) {
//                user, friends in
//                //将两个信号合并成一个信号，并压缩成一个元组返回（两个信号均成功）
//                return (user, friends)
//            }
//            .observeOn(MainScheduler.instance) //加这个是应为请求在后台线程，下面的绑定在前台线程。
//            .subscribe(onNext: { (user, friends) in
//                //将数据绑定到界面上
//                //.......
//            })
//            .disposed(by: disposeBag)
//    }
    
    
    /// 该方法同样是将多个（两个或两个以上的）Observable 序列元素进行合并。
    /// 但与 zip 不同的是，每当任意一个 Observable 有新的事件发出时，它
    /// 会将每个 Observable 序列的最新的一个事件元素进行合并。
    func combineLatest() {
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<String>()
         
        Observable.combineLatest(subject1, subject2) {
            "\($0)\($1)"
            }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
         
        subject1.onNext(1)
        subject2.onNext("A")
        subject1.onNext(2)
        subject2.onNext("B")
        subject2.onNext("C")
        subject2.onNext("D")
        subject1.onNext(3)
        subject1.onNext(4)
        subject1.onNext(5)
    }
    
    /// 该方法将两个 Observable 序列合并为一个。每当 self
    /// 队列发射一个元素时，便从第二个序列中取出最新的一个值。
    func withLatestFrom() {
        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()
         
        subject1.withLatestFrom(subject2)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
         
        subject1.onNext("A")
        subject2.onNext("1")
        subject1.onNext("B")
        subject1.onNext("C")
        subject2.onNext("2")
        subject1.onNext("D")
    }
    
    /// switchLatest 有点像其他语言的 switch 方法，可以对事件流进行转换。
    /// 比如本来监听的 subject1，我可以通过更改 variable 里面的 value
    /// 更换事件源。变成监听 subject2。
    func switchLatest() {
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
         
        let relay = BehaviorRelay.init(value: subject1)
        
        relay.asObservable()
            .switchLatest()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
         
        subject1.onNext("B")
        subject1.onNext("C")
         
        //改变事件源
        relay.accept(subject2)
        subject1.onNext("D")
        subject2.onNext("2")
         
        //改变事件源
        relay.accept(subject1)
        subject2.onNext("3")
        subject1.onNext("E")
    }
}
