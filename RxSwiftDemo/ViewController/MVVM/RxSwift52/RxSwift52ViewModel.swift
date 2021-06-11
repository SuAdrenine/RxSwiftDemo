//
//  RxSwift52ViewModel.swift
//  RxSwiftDemo
//
//  Created by Kystar's Mac Book Pro on 2021/6/10.
//

import Foundation
import RxSwift

class RxSwift52ViewModel {
    // 数据请求服务
    let networkService = RxSwift52GitHubService()
    
    // 输入部分：查询
    fileprivate let searchAction: Observable<String>
    
    // 输出部分：查询结果
    let searchRessult: Observable<RxSwift52GitHubRepositories>
    // 查询结果资源列表
    let repositories: Observable<[RxSwift52GitHubRepository]>
    
    // 清空结果
    let cleanResult: Observable<Void>
    
    // 导航栏标题
    let navigationTitle: Observable<String>
    
    // ViewModel初始化（根据输入实现对应输出）
    init(searchAction: Observable<String>) {
        self.searchAction = searchAction
        
        // 生成查询结果序列
        self.searchRessult = searchAction
            .filter { !$0.isEmpty}  //输入为空不发送请求
            .flatMapLatest(networkService.searchRepositories)   //可使用flatMapFirst
            .share(replay: 1)   //让http请求是被共享的
        
        // 生成清空结果动作序列
        self.cleanResult = searchAction
            .filter{ $0.isEmpty}
            .map{ _ in Void()}
        
        //生成查询结果里的资源列表序列（如果查询到结果则返回结果，如果是清空数据则返回空数组）
        self.repositories = Observable.of(searchRessult.map{$0.items},cleanResult.map{[]}).merge()
        
        //生成导航栏标题序列（如果查询到结果则返回数量，如果是清空数据则返回默认标题）
        self.navigationTitle = Observable.of(searchRessult.map{ "共有\($0.totalCount!)个结果"}, cleanResult.map{"请输入搜索内容"}).merge()
    }
}
