//
//  RxSwift6ViewController.swift
//  RxSwiftDemo
//
//  Created by Kystar's Mac Book Pro on 2021/3/24.
//

import RxSwift
import RxCocoa

/*
 自定义可绑定属性
 */
class RxSwift6ViewController: BaseViewController {

    lazy var label1: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        return label
    }()
    
    lazy var label2: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        return label
    }()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(label1)
        view.addSubview(label2)
        label1.frame = CGRect.init(x: 10, y: 100, width: 100, height: 50)
        label2.frame = CGRect.init(x: 10, y: 200, width: 100, height: 50)
        
        let observable1 = Observable<Int>.interval(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        observable1
            .map {CGFloat($0)}
            .bind(to: label1.by_fontSize1)
            .disposed(by: disposeBag)
        
        let observable2 = Observable<Int>.interval(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        observable2
            .map {CGFloat($0)}
            .bind(to: label2.rx.by_fontSize2)
            .disposed(by: disposeBag)
    }
    
}

//通过对 UI 类进行扩展
//对 UILabel 进行扩展，增加了一个 fontSize 可绑定属性。
extension UILabel {
    public var by_fontSize1: Binder<CGFloat> {
        return Binder(self) {label, fontsize in
            label.font = UIFont.systemFont(ofSize: fontsize)
        }
    }
}

//更规范的写法应该是对 Reactive 进行扩展。这里同样是给 UILabel 增加了一个 fontSize 可绑定属性。
//（注意：这种方式下，我们绑定属性时要写成 label.rx.fontSize）
extension Reactive where Base: UILabel {
    public var by_fontSize2: Binder<CGFloat> {
        return Binder(self.base) { label, fontSize in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
}

extension Reactive where Base: UILabel {
     
    /// Bindable sink for `text` property.
    public var by_text: Binder<String?> {
        return Binder(self.base) { label, text in
            label.text = text
        }
    }
 
    /// Bindable sink for `attributedText` property.
    public var by_attributedText: Binder<NSAttributedString?> {
        return Binder(self.base) { label, text in
            label.attributedText = text
        }
    }
     
}


