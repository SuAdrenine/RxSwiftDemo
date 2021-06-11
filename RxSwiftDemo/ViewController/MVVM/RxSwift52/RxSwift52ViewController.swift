//
//  RxSwift52ViewController.swift
//  RxSwiftDemo
//
//  Created by Kystar's Mac Book Pro on 2021/6/10.
//

import UIKit
import RxSwift
import RxCocoa

class RxSwift52ViewController: BaseViewController {
    
    var tableView: UITableView!
    var searchBar: UISearchBar!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: self.view.frame, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 56))
        tableView.tableHeaderView = searchBar
        
        // 查询条件输入
        let searchAction = searchBar.rx.text.orEmpty
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)  // 间隔超过0.5秒才发送
            .distinctUntilChanged()
            .asObservable()
        
        // 初始化viewModel
        let viewModel = RxSwift52ViewModel(searchAction: searchAction)
        
        // 绑定标题
        viewModel.navigationTitle
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        // 将数据绑定到表格
        viewModel.repositories
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
                cell.textLabel?.text = element.name
                cell.detailTextLabel?.text = element.htmlUrl
                return cell
            }.disposed(by: disposeBag)
        
        // 单元格点击
        tableView.rx.modelSelected(RxSwift52GitHubRepository.self)
            .subscribe(onNext: {[weak self] item in
                // 显示其他信息
                self?.showAlert(title: item.fullName, message: item.description)
            }).disposed(by: disposeBag)
    }
    
    //显示消息
    func showAlert(title:String, message:String){
        let alertController = UIAlertController(title: title,
                                                message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
