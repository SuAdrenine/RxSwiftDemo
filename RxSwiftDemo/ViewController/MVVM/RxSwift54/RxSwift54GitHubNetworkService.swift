//
//  RxSwift54GitHubNetworkService.swift
//  RxSwiftDemo
//
//  Created by Kystar's Mac Book Pro on 2021/6/19.
//

import Foundation
import RxSwift

class RxSwift54GitHubNetworkService {
    //验证用户是否存在
    func usernameAvailable(_ username: String) -> Observable<Bool> {
        //通过检查这个用户的GitHub主页是否存在来判断用户是否存在
        let url = URL(string: "https://github.com/\(username.URLEscaped)")!
        let request = URLRequest(url: url)
        return URLSession.shared.rx.response(request: request)
            .map { pair in
                //如果不存在该用户主页，则说明这个用户名可用
                return pair.response.statusCode == 404
            }
            .catchErrorJustReturn(false)
    }
    
    //注册用户
    func signup(_ username: String, password: String) -> Observable<Bool> {
        //这里我们没有真正去发起请求，而是模拟这个操作（平均每5次有1次失败）
        let signupResult = arc4random() % 5 == 0 ? false : true
        return Observable.just(signupResult)
            .delay(RxTimeInterval.milliseconds(1500), scheduler: MainScheduler.instance) //结果延迟1.5秒返回
    }
}

//扩展String
extension String {
    //字符串的url地址转义
    var URLEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}
