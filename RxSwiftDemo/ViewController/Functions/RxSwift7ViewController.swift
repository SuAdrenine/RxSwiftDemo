//
//  RxSwift7ViewController.swift
//  RxSwiftDemo
//
//  Created by Kystar's Mac Book Pro on 2021/3/24.
//

import RxSwift
import RxCocoa

//Subjects 既是订阅者，也是 Observable：
//它是订阅者，是因为它能够动态地接收新的值。
//它又是一个 Observable，是因为当 Subjects 有了新的值之后，就会通过 Event 将新值发出给他的所有订阅者。
//一共有四种 Subjects，分别为：PublishSubject、BehaviorSubject、ReplaySubject、Variable。他们之间既有各自的特点，他们之间最大的区别只是在于：当一个新的订阅者刚订阅它的时候，能不能收到 Subject 以前发出过的旧 Event，如果能的话又能收到多少个。
// 常用方法：
//onNext(:)：是 on(.next(:)) 的简便写法。该方法相当于 subject 接收到一个 .next 事件。
//onError(:)：是 on(.error(:)) 的简便写法。该方法相当于 subject 接收到一个 .error 事件。
//onCompleted()：是 on(.completed) 的简便写法。该方法相当于 subject 接收到一个 .completed 事件。

class RxSwift7ViewController: BaseViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //        publishSubject()
        //        behaviorSubject()
        //        replaySubject()
        //        variable()
        //        behaviorRelay()
    }
    
    
    /// PublishSubject 是最普通的 Subject，它不需要初始值就能创建。
    /// PublishSubject 的订阅者从他们开始订阅的时间点起，可以收到订阅后 Subject 发出的新 Event，而不会收到他们在订阅前已发出的 Event。
    func publishSubject() {
        let subject = PublishSubject<String>()
        //由于当前没有任何订阅者，所以这条信息不会输出到控制台
        subject.onNext("111")
        //第1次订阅subject
        subject.subscribe(onNext: { string in
            print("第1次订阅：", string)
        }, onCompleted:{
            print("第1次订阅：onCompleted")
        }).disposed(by: disposeBag)
        
        //当前有1个订阅，则该信息会输出到控制台
        subject.onNext("222")
        
        //第2次订阅subject
        subject.subscribe(onNext: { string in
            print("第2次订阅：", string)
        }, onCompleted:{
            print("第2次订阅：onCompleted")
        }).disposed(by: disposeBag)
        
        //当前有2个订阅，则该信息会输出到控制台
        subject.onNext("333")
        
        //让subject结束
        subject.onCompleted()
        
        //subject完成后会发出.next事件了。
        subject.onNext("444")
        
        //subject完成后它的所有订阅（包括结束后的订阅），都能收到subject的.completed事件，
        subject.subscribe(onNext: { string in
            print("第3次订阅：", string)
        }, onCompleted:{
            print("第3次订阅：onCompleted")
        }).disposed(by: disposeBag)
    }
    
    //    BehaviorSubject 需要通过一个默认初始值来创建。
    //    当一个订阅者来订阅它的时候，这个订阅者会立即收到 BehaviorSubjects 上一个发出的 event。之后就跟正常的情况一样，它也会接收到 BehaviorSubject 之后发出的新的 event。
    func behaviorSubject() {
        let subject = BehaviorSubject(value: "111")
        
        // 第1次订阅
        subject.subscribe { event in
            print("第一次订阅:", event)
        }.disposed(by: disposeBag)
        
        // 发送next事件
        subject.onNext("222")
        
        // 发送next事件
        subject.onNext("333")
        
        // 第2次订阅
        subject.subscribe { event in
            print("第二次订阅：",event)
        }.disposed(by: disposeBag)
        
        // 发送error事件
        subject.onError(NSError.init(domain: "by", code: -1, userInfo: nil))
        
        // 第3次订阅
        subject.subscribe { event in
            print("第三次订阅：",event)
        }.disposed(by: disposeBag)
    }
    
    /// ReplaySubject在创建时候需要设置一个bufferSize，表示它对于它发送过
    /// 的event的缓存个数，例如bufferSize=2，且发已经发出了A，B，C 3个.next
    /// 的event，那么他会缓存B，C两个事件，此时有一个subscriber订阅了该subject，
    /// 那么他会立即受到B，C事件
    /// 如果一个 subscriber 订阅已经结束的 ReplaySubject，除了会收到缓存的 .next 的 event 外，还会收到那个终结的 .error 或者 .complete 的 event。
    func replaySubject() {
        let subject = ReplaySubject<String>.create(bufferSize: 2)
        
        // 连续发送3个事件
        subject.onNext("111")
        subject.onNext("222")
        subject.onNext("333")
        
        // 第一次订阅
        subject.subscribe { event in
            print("第一次订阅：",event)
        }.disposed(by: disposeBag)
        
        subject.onNext("444")
        
        // 第二次订阅
        subject.subscribe { event in
            print("第二次订阅：",event)
        }.disposed(by: disposeBag)
        
        subject.onCompleted()
        
        subject.subscribe { event in
            print("第三次订阅：",event)
        }.disposed(by: disposeBag)
    }
    /// （注意：由于 Variable 在之后版本中将被废弃，建议使用 Varible 的地方都改用下面介绍的 BehaviorRelay 作为替代。）
    /// Variable 其实就是对 BehaviorSubject 的封装，所以它也必须要通过一个默认的初始值进行创建。
    //    Variable 具有 BehaviorSubject 的功能，能够向它的订阅者发出上一个 event 以及之后新创建的 event。
    //    不同的是，Variable 还把会把当前发出的值保存为自己的状态。同时它会在销毁时自动发送 .complete 的 event，不需要也不能手动给 Variables 发送 completed 或者 error 事件来结束它。
    //    简单地说就是 Variable 有一个 value 属性，我们改变这个 value 属性的值就相当于调用一般 Subjects 的 onNext() 方法，而这个最新的 onNext() 的值就被保存在 value 属性里了，直到我们再次修改它。
    //    注意：
    //    Variables 本身没有 subscribe() 方法，但是所有 Subjects 都有一个 asObservable() 方法。我们可以使用这个方法返回这个 Variable 的 Observable 类型，拿到这个 Observable 类型我们就能订阅它了。
    func variable() {
        //        //创建一个初始值为111的Variable
        //        let variable = Variable("111")
        //
        //        //修改value值
        //        variable.value = "222"
        //
        //        //第1次订阅
        //        variable.asObservable().subscribe {
        //            print("第1次订阅：", $0)
        //        }.disposed(by: disposeBag)
        //
        //        //修改value值
        //        variable.value = "333"
        //
        //        //第2次订阅
        //        variable.asObservable().subscribe {
        //            print("第2次订阅：", $0)
        //        }.disposed(by: disposeBag)
        //
        //        //修改value值
        //        variable.value = "444"
    }
    
    func behaviorRelay() {
        let subject = BehaviorRelay<String>(value: "111")
        
        subject.accept("222")
        
        subject.asObservable().subscribe {
            print("第1次订阅：",$0)
        }.disposed(by: disposeBag)
        
        subject.accept("333")
        
        subject.asObservable().subscribe {
            print("第2次订阅：",$0)
        }.disposed(by: disposeBag)
        
        subject.accept("444")
        
        
//        如果想将新值合并到原值上，可以通过 accept() 方法与 value 属性配合来实现。（这个常用在表格上拉加载功能上，BehaviorRelay 用来保存所有加载到的数据）
        //创建一个初始值为包含一个元素的数组的BehaviorRelay
        let subject2 = BehaviorRelay<[String]>(value: ["1"])
        
        //修改value值
        subject2.accept(subject2.value + ["2", "3"])
        
        //第1次订阅
        subject2.asObservable().subscribe {
            print("subject2 第1次订阅：", $0)
        }.disposed(by: disposeBag)
        
        //修改value值
        subject2.accept(subject2.value + ["4", "5"])
        
        //第2次订阅
        subject2.asObservable().subscribe {
            print("subject2 第2次订阅：", $0)
        }.disposed(by: disposeBag)
        
        //修改value值
        subject2.accept(subject2.value + ["6", "7"])
    }
}
