//
//  RxSwift53GitHubService.swift
//  RxSwiftDemo
//
//  Created by Kystar's Mac Book Pro on 2021/6/18.
//

import Foundation
import RxSwift
import RxCocoa
import ObjectMapper
 
class GitHubNetworkService {
     
    //搜索资源数据
    func searchRepositories(query:String) -> Driver<RxSwift53GitHubRepositories> {
        return RxSwift53GitHubProvider.rx.request(.repositories(query))
            .filterSuccessfulStatusCodes()
            .mapObject(RxSwift53GitHubRepositories.self)
            .asDriver(onErrorDriveWith: Driver.empty())
    }
}
