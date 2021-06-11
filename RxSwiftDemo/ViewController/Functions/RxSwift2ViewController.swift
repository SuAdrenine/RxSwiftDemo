//
//  RxSwift2ViewController.swift
//  RxSwiftDemo
//
//  Created by Kystar's Mac Book Pro on 2021/3/22.
//

import RxSwift
import RxCocoa

struct Music {
    let name: String
    let singer: String
    
    init(name: String, singer: String) {
        self.name = name
        self.singer = singer
    }
}

extension Music: CustomStringConvertible {
    var description: String {
        return "name: \(name) singer: \(singer)"
    }
}

struct MusicListViewModel {
    //这里我们将 data 属性变成一个可观察序列对象（Observable Squence），而对象当中的内容和我们之前在数组当中所包含的内容是完全一样的。
    let data = Observable.just([
        Music(name: "无条件", singer: "陈奕迅"),
        Music(name: "你曾是少年", singer: "S.H.E"),
        Music(name: "从前的我", singer: "陈洁仪"),
        Music(name: "在木星", singer: "朴树"),
    ])
}

class RxSwift2ViewController: BaseViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: self.view.bounds, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    
    // 自动释放绑定的资源。它是通过类似“订阅处置机制”方式实现（类似于 NotificationCenter 的 removeObserver）。
    let disposeBag = DisposeBag()
    let viewModel = MusicListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.addSubview(self.tableView)
        // rx.items(cellIdentifier:）:这是 Rx 基于 cellForRowAt 数据源方法的一个封装。传统方式中我们还要有个 numberOfRowsInSection 方法，使用 Rx 后就不再需要了（Rx 已经帮我们完成了相关工作）。
        viewModel.data.bind(to: tableView.rx.items(cellIdentifier: "cell")) { _, music, cell in
            cell.textLabel?.text = music.name
            cell.detailTextLabel?.text = music.singer
        }.disposed(by: disposeBag)
        // rx.modelSelected： 这是 Rx 基于 UITableView 委托回调方法 didSelectRowAt 的一个封装。
        tableView.rx.modelSelected(Music.self).subscribe(onNext: {music in
            print("\(music)")
        }).disposed(by: disposeBag)
    }
    

}
