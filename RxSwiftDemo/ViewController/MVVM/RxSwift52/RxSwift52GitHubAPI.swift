//
//  RxSwift52GitHubAPI.swift
//  RxSwiftDemo
//
//  Created by Kystar's Mac Book Pro on 2021/6/10.
//

import Foundation
import Moya

// 初始化GitHub请求的provider
let RxSwift52GitHubProvider = MoyaProvider<RxSwift52GitHubAPI>()

/// 下面定义GitHub请求都endpoints（供provider使用）
/// 请求分类
public enum RxSwift52GitHubAPI {
    case repositories(String)   //查询资源库
}

extension RxSwift52GitHubAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    public var path: String {
        switch self {
        case .repositories:
            return "/search/repositories"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    /// 这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        print("发起请求。")
        switch self {
        case .repositories(let query):
            var params: [String: Any] = [:]
            params["q"] = query
            params["sort"] = "stars"
            params["order"] = "desc"
            return .requestParameters(parameters: params,
                                      encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        nil
    }

}

