//
//  RxSwift3ViewController.swift
//  RxSwiftDemo
//
//  Created by Kystar's Mac Book Pro on 2021/3/22.
//

import RxSwift
import RxCocoa

/*
Observable<T>可观察序列。异步地产生一系列的Event（事件），Event还可以携带数据，
 它的泛型<T>可以指定携的数据的类型。
有了可观察序列，我们还需要Observer（订阅者）来订阅它，这样这个订阅者才能收到
 Observable<T>不时发出的Event。
Event的类型：
 next：next 事件就是那个可以携带数据 <T> 的事件，可以说它就是一个“最正常”的事件。
 error：error 事件表示一个错误，它可以携带具体的错误内容，一旦 Observable 发出了 error event，则这个 Observable 就等于终止了，以后它再也不会发出 event 事件了。
 completed：completed 事件表示 Observable 发出的事件正常地结束了，跟 error 一样，一旦 Observable 发出了 completed event，则这个 Observable 就等于终止了，以后它再也不会发出 event 事件了。
*/

enum RxSwift3ViewControllerError: Error {
    case A
    case B
}

class RxSwift3ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        interval()
        
    }
    
    func just() {
//        该方法通过传入一个默认值来初始化。
        let _ = Observable<Int>.just(5)
        
    }
    
    func of() {
//        该方法可以接受可变数量的参数（必需要是同类型的）
        let _ = Observable.of("A", "B", "C")
    }
    
    func from() {
//        该方法需要一个数组参数。数组内的元素会被当成event携带的内容，而不是数组，与上面of()等效
        let _ = Observable.from(["A", "B", "C"])
    }

    func empty() {
//        该方法创建一个空内容的 Observable 序列。
        let _ = Observable<Int>.empty()
    }
    
    func never() {
//        该方法创建一个永远不会发出 Event（也不会终止）的 Observable 序列。
        let _ = Observable<Int>.never()
    }
    
    func error() {
//        该方法创建一个不做任何操作，而是直接发送一个错误的 Observable 序列。
        let _ = Observable<Int>.error(RxSwift3ViewControllerError.A)
    }
    
    func range() {
//        该方法通过指定起始和结束数值，创建一个以这个范围内所有值作为初始值的 Observable 序列。
//        下面两个等效
        let _ = Observable.range(start: 1, count: 5)
        let _ = Observable.of(1, 2, 3, 4, 5)
    }
    
    
    func repeatElement() {
//        该方法创建一个可以无限发出给定元素的 Event 的 Observable 序列（永不终止）。
        let _ = Observable.repeatElement(1)
    }
    
    func generate() {
//        该方法创建一个只有当提供的所有的判断条件都为 true 的时候，才会给出动作的 Observable 序列。
//        下面两个等效
        let _ = Observable.generate(
            initialState: 0,
            condition: {$0 <= 10},
            iterate: {$0 + 2}
        )
        let _ = Observable.of(0, 2, 4, 6, 8, 10)
    }
    
    func create() {
//        该方法接受一个 block 形式的参数，任务是对每一个过来的订阅进行处理。
        //这个block有一个回调参数observer就是订阅这个Observable对象的订阅者
        //当一个订阅者订阅这个Observable对象的时候，就会将订阅者作为参数传入这个block来执行一些内容
        let observable = Observable<String>.create{observer in
            //对订阅者发出了.next事件，且携带了一个数据
            observer.onNext("666")
            //对订阅者发出了.completed事件
            observer.onCompleted()
            //因为一个订阅行为会有一个Disposable类型的返回值，所以在结尾一定要returen一个Disposable
            return Disposables.create()
        }
        
        _ = observable.subscribe {
            print($0)
        }
    }
    
    func deferred() {
//        该个方法相当于是创建一个 Observable 工厂，通过传入一个 block 来执行延迟 Observable 序列创建的行为，而这个 block 里就是真正的实例化序列对象的地方。
        
        // 奇数/偶数
        var isOdd = true
        
        let factory: Observable<Int> = Observable.deferred {
            isOdd = !isOdd
            
            if isOdd {
                return Observable.of(1, 3, 5, 7)
            } else {
                return Observable.of(2, 4, 6, 8)
            }
        }
        
        _ = factory.subscribe { event in
            print("\(isOdd)", event)
        }
        
        _ = factory.subscribe { event in
            print("\(isOdd)", event)
        }
    }
    
    func interval() {
//        这个方法创建的 Observable 序列每隔一段设定的时间，会发出一个索引数的元素。而且它会一直发送下去。
//        下面方法让其每 1 秒发送一次，并且是在主线程（MainScheduler）发送。
        let observable = Observable<Int>.interval(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        _ = observable.subscribe { event in
            print(event)
        }
    }
    
    func timer() {
//        这个方法有两种用法
        
//        (1)一种是创建的 Observable 序列在经过设定的一段时间后，产生唯一的一个元素。
        let observable1 = Observable<Int>.timer(DispatchTimeInterval.seconds(5), scheduler: MainScheduler.instance)
        _ = observable1.subscribe { event in
            print(event)
        }

//        （2）另一种是创建的 Observable 序列在经过设定的一段时间后，每隔一段时间产生一个元素。
        let observable2 = Observable<Int>.timer(DispatchTimeInterval.seconds(5), period: DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        _ = observable2.subscribe { event in
            print(event)
        }
    }
}
