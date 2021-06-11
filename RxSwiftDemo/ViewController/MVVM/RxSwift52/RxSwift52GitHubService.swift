//
//  RxSwift52GitHubService.swift
//  RxSwiftDemo
//
//  Created by Kystar's Mac Book Pro on 2021/6/10.
//

import Foundation
import RxSwift
import RxCocoa
import Moya_ObjectMapper

class RxSwift52GitHubService {
    func searchRepositories(query: String) -> Observable<RxSwift52GitHubRepositories> {
        return RxSwift52GitHubProvider.rx.request(.repositories(query))
            .filterSuccessfulStatusCodes()
            .mapObject(RxSwift52GitHubRepositories.self)
            .asObservable()
            .catchError({ error in
                print("发生错误：",error.localizedDescription)
                return Observable<RxSwift52GitHubRepositories>.empty()
            })
    }
}
