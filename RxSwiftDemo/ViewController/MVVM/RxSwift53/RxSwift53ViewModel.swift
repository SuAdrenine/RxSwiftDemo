//
//  RxSwift53ViewModel.swift
//  RxSwiftDemo
//
//  Created by Kystar's Mac Book Pro on 2021/6/18.
//

import Foundation
import RxSwift
import RxCocoa

class RxSwift53ViewModel {
    fileprivate let searchAction: Driver<String>
    let searchResult: Driver<RxSwift53GitHubRepositories>
    let repositories: Driver<[RxSwift53GitHubRepository]>
    let cleanResult: Driver<Void>
    let navigationTitle: Driver<String>
    
    init(searchAction: Driver<String>) {
        self.searchAction = searchAction
        self.searchResult = searchAction
            .filter{ !$0.isEmpty}
            .flatMapLatest {
                RxSwift53GitHubProvider.rx.request(.repositories($0))
                    .filterSuccessfulStatusCodes()
                    .mapObject(RxSwift53GitHubRepositories.self)
                    .asDriver(onErrorDriveWith: Driver.empty())
            }
        self.cleanResult = searchAction.filter{$0.isEmpty}
            .map{_ in Void()}
        
        self.repositories = Driver.merge(searchResult.map{ $0.items }, cleanResult.map{[]})
        //生成导航栏标题序列（如果查询到结果则返回数量，如果是清空数据则返回默认标题）
        self.navigationTitle = Driver.merge(searchResult.map{ "共有\($0.totalCount!)个结果"}, cleanResult.map{"请输入搜索内容"})
    }
}
