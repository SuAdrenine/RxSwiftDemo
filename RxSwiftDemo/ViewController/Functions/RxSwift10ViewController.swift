//
//  RxSwift10ViewController.swift
//  RxSwiftDemo
//
//  Created by Kystar's Mac Book Pro on 2021/5/26.
//

import RxSwift
import RxCocoa

class RxSwift10ViewController: BaseViewController {
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        amb()
//        takeWhile()
//        takeUntil()
//        skipWhile()
        skipUntil()
    }
    
    /// 当传入多个 Observables 到 amb 操作符时，它将取第一个发出元素或产生事件的 Observable，然后只发出它的元素。并忽略掉其他的 Observables。
    func amb() {
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<Int>()
        let subject3 = PublishSubject<Int>()
         
        subject1
            .amb(subject2)
            .amb(subject3)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
         
        subject2.onNext(1)
        subject1.onNext(20)
        subject2.onNext(2)
        subject1.onNext(40)
        subject3.onNext(0)
        subject2.onNext(3)
        subject1.onNext(60)
        subject3.onNext(0)
        subject3.onNext(0)
    }
    
    /// 该方法依次判断 Observable 序列的每一个值是否满足给定的条件。
    /// 当第一个不满足条件的值出现时，它便自动完成。
    func takeWhile() {
         
        Observable.of(2, 3, 4, 5, 6)
            .takeWhile({$0 < 4})
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    /// 除了订阅源 Observable 外，通过 takeUntil 方法我们还可以监视另外
    /// 一个 Observable， 即 notifier。如果 notifier 发出值或 complete
    /// 通知，那么源 Observable 便自动完成，停止发送事件。
    func takeUntil() {
        let source = PublishSubject<String>()
        let notifier = PublishSubject<Int>()
         
        source
            .takeUntil( notifier)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
         
        source.onNext("a")
        source.onNext("b")
        source.onNext("c")
        source.onNext("d")
         
        //停止接收消息
        notifier.onNext(0)
         
        source.onNext("e")
        source.onNext("f")
        source.onNext("g")
    }
    
    
    /// 该方法用于跳过前面所有满足条件的事件。一旦遇到不满足条件的事件，之后就不会再跳过了。
    func skipWhile() {
        Observable.of(2, 3, 4, 5, 6)
            .skipWhile({$0 < 4 })
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    /// 同上面的 takeUntil 一样，skipUntil 除了订阅源 Observable 外，
    /// 通过 skipUntil 方法我们还可以监视另外一个 Observable， 即 notifier 。
    /// 与 takeUntil 相反的是。源 Observable 序列事件默认会一直跳过，直到
    ///  notifier 发出值或 complete 通知。
    func skipUntil() {
        let source = PublishSubject<String>()
        let notifier = PublishSubject<Int>()
         
        source
            .skipUntil(notifier)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
         
        source.onNext("A")
        source.onNext("B")
        source.onNext("C")
        source.onNext("D")
        source.onNext("E")
         
        //开始接收消息
        notifier.onNext(0)
         
        source.onNext("F")
        source.onNext("G")
        source.onNext("H")
         
        //仍然接收消息
        notifier.onNext(0)
         
        source.onNext("I")
    }
}
