//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by Kystar's Mac Book Pro on 2021/3/20.
//

import RxSwift
import RxCocoa

struct ViewControllerDataModel {
    let vcName: String
    let title: String
    let url: String?
    
    init(vcName: String, title: String) {
        self.vcName = vcName
        self.title = title
        self.url = nil
    }
}

extension ViewControllerDataModel: CustomStringConvertible {
    var description: String {
        return "vc name:\(vcName) titel:\(title)"
    }
}

class RootViewController: BaseViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: view.bounds, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    let datas = Observable.just([
        ViewControllerDataModel.init(vcName: "RxSwift2ViewController", title: "RxSwift的使用详解2（响应式编程与传统式编程的比较样例）"),
        ViewControllerDataModel.init(vcName: "RxSwift3ViewController", title: "RxSwift的使用详解3（Observable介绍、创建可观察序列）"),
        ViewControllerDataModel.init(vcName: "RxSwift4ViewController", title: "RxSwift的使用详解4（Observable订阅、事件监听、订阅销毁）"),
        ViewControllerDataModel.init(vcName: "RxSwift5ViewController", title: "RxSwift的使用详解5（观察者1： AnyObserver、Binder）"),
        ViewControllerDataModel.init(vcName: "RxSwift6ViewController", title: "RxSwift的使用详解6（观察者2： 自定义可绑定属性）"),
        ViewControllerDataModel.init(vcName: "RxSwift7ViewController", title: "RxSwift的使用详解7（Subjects、Variables）")
    ])
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.addSubview(tableView)
        datas.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { _, data, cell in
//            let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "cell")
            cell.textLabel?.text = data.vcName
            cell.detailTextLabel?.text = data.title
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ViewControllerDataModel.self).subscribe(onNext: {data in
//            print("\(data)")
            let vc = UIViewController.classFromString(data.vcName)
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
    }


}

