//
//  RxSwift5ViewController.swift
//  RxSwiftDemo
//
//  Created by Kystar's Mac Book Pro on 2021/3/23.
//

import RxSwift
import RxCocoa

/*
 观察者（Observer）的作用就是监听事件，然后对这个事件做出响应。或者说任何响应事件的行为都是观察者。比如：
 当我们点击按钮，弹出一个提示框。那么这个“弹出一个提示框”就是观察者 Observer<Void>
 当我们请求一个远程的 json 数据后，将其打印出来。那么这个“打印 json 数据”就是观察者 Observer<JSON>
 */
class RxSwift5ViewController: BaseViewController {

    lazy var bindLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        return label
    }()
    
    lazy var bindToLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        return label
    }()
    
    lazy var binderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        return label
    }()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.addSubview(bindLabel)
        bindLabel.frame = CGRect.init(x: 10, y: 100, width: 100, height: 50)
        view.addSubview(bindToLabel)
        bindToLabel.frame = CGRect.init(x: 10, y: 200, width: 100, height: 50)
        view.addSubview(binderLabel)
        binderLabel.frame = CGRect.init(x: 10, y: 300, width: 100, height: 50)
        
//        createObserverBySubscribe()
//        createObserverByBind()
//        createObserverByAnyObserverAndSubscribe()
//        createObsererByAnyObserverAndBindTo()
//        cerateObserverByBinder()
//        binderExample()
    }
    
    /// 在 subscribe 方法中创建观察者
    func createObserverBySubscribe() {
//        （1）创建观察者最直接的方法就是在 Observable 的 subscribe 方法后面描述当事件发生时，需要如何做出响应。
//        （2）比如下面的样例，观察者就是由后面的 onNext，onError，onCompleted 这些闭包构建出来的。
        let observable = Observable.of("A", "B", "C")
        _ = observable.subscribe(onNext: { element in
            
        }, onError: { error in
            
        }, onCompleted: {
            
        }, onDisposed: {
            
        })
    }
    
    /// 在 bind 方法中创建
    func createObserverByBind() {
        
        let observable = Observable<Int>.interval(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        observable
            .map { "当前显示：\($0)"}
            .bind { [weak self](text) in
                self?.bindLabel.text = text
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - ---- AnyObserver 可以用来描叙任意一种观察者。
    /// AnyObserver + Subscribe
    func createObserverByAnyObserverAndSubscribe() {
        let observer: AnyObserver<String> = AnyObserver { event in
            switch event {
            case .next(let data):
                print(data)
            case .error(let error):
                print(error)
            case .completed:
                print("completed")
            }
        }
        let observable = Observable.of("A", "B", "C")
        _ = observable.subscribe(observer)
    }
    
    /// AnyObserver + bingTo
    func createObsererByAnyObserverAndBindTo() {
        let observer: AnyObserver<String> = AnyObserver { [weak self] event in
            switch event {
            case .next(let text):
                self?.bindToLabel.text = text
            default:
                break
            }
        }
        let observable = Observable<Int>.interval(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        _ = observable
            .map { "当前显示：\($0)" }
            .bind(to: observer)
            .disposed(by: disposeBag)
    }
    
    // MARK: - ---- Binder 更专注于特定的场景
//    不会处理错误事件，一旦产生错误事件，在调试环境下将执行 fatalError，在发布环境下将打印错误信息。
//    确保绑定都是在给定 Scheduler 上执行（默认 MainScheduler）
    func cerateObserverByBinder() {
        let observer: Binder<String> = Binder(binderLabel) { (label, text) in
            label.text = text
        }
        
        let observable = Observable<Int>.interval(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        observable
            .map { "当前显示： \($0)" }
            .bind(to: observer)
            .disposed(by: disposeBag)
    }
    
    func binderExample() {
//        extension Reactive where Base: UIControl {
//
//            /// Bindable sink for `enabled` property.
//            public var isEnabled: Binder<Bool> {
//                return Binder(self.base) { control, value in
//                    control.isEnabled = value
//                }
//            }
//        }
    }
    
}


