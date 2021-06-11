//
//  RxSwift52GitHubModel.swift
//  RxSwiftDemo
//
//  Created by Kystar's Mac Book Pro on 2021/6/10.
//

import Foundation
import ObjectMapper

/// 包含查询返回的所有库模型
struct RxSwift52GitHubRepositories: Mappable {
    var totalCount: Int!
    var incompleteResults: Bool!
    var items: [RxSwift52GitHubRepository]! // 本次查询返回的所有仓库的集合
    
    init() {
        print("init()")
        totalCount = 0
        incompleteResults = false
        items = []
    }
    
    init?(map: Map) { }
    
    /// Mappable
    mutating func mapping(map: Map) {
        totalCount <- map["total_count"]
        incompleteResults <- map["incomplete_results"]
        items <- map["items"]
    }
}

struct RxSwift52GitHubRepository: Mappable {
    var id: Int!
    var name: String!
    var fullName: String!
    var htmlUrl: String!
    var description: String!
    
    init?(map: Map) { }
    
    /// Mappable
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        fullName <- map["full_name"]
        htmlUrl <- map["html_url"]
        description <- map["description"]
    }
}
