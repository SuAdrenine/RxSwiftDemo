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
        ViewControllerDataModel.init(vcName: "RxSwift7ViewController", title: "RxSwift的使用详解7（Subjects、Variables）"),
        ViewControllerDataModel.init(vcName: "RxSwift8ViewController", title: "RxSwift的使用详解8（变换操作符：buffer、map、flatMap、scan等）"),
        ViewControllerDataModel.init(vcName: "RxSwift9ViewController", title: "RxSwift的使用详解9（过滤操作符：filter、take、skip等）"),
        ViewControllerDataModel.init(vcName: "RxSwift10ViewController", title: "RxSwift的使用详解10（条件和布尔操作符：amb、takeWhile、skipWhile等）"),
        ViewControllerDataModel.init(vcName: "RxSwift11ViewController", title: "RxSwift的使用详解11（结合操作符：startWith、merge、zip等）"),
        ViewControllerDataModel.init(vcName: "RxSwift12ViewController", title: "RxSwift的使用详解12（算数&聚合操作符：toArray、reduce、concat）"),
        ViewControllerDataModel.init(vcName: "RxSwift13ViewController", title: "RxSwift的使用详解13（连接操作符：connect、publish、replay、multicast）"),
        ViewControllerDataModel.init(vcName: "RxSwift34ViewController", title: "RxSwift的使用详解34（UITableView的使用5：可编辑表格）"),
        ViewControllerDataModel.init(vcName: "RxSwift52ViewController", title: "RxSwift的使用详解52（MVVM架构演示2：使用Observable样例）")
    ])
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.addSubview(tableView)
        //        datas.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { _, data, cell in
        ////            let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "cell")
        //            cell.textLabel?.text = data.vcName
        //            cell.detailTextLabel?.text = data.title
        //        }.disposed(by: disposeBag)
        
        datas.bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            cell.textLabel?.text = element.vcName
            cell.detailTextLabel?.text = element.title
            return cell
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ViewControllerDataModel.self).subscribe(onNext: {data in
            //            print("\(data)")
            let vc = UIViewController.classFromString(data.vcName)
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
    }
    
    
}

