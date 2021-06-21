//
//  RxSwift54GitHubSignupService.swift
//  RxSwiftDemo
//
//  Created by Kystar's Mac Book Pro on 2021/6/21.
//

import Foundation
import RxSwift

class RxSwift54GitHubSignupService {
    
    let minPasswordCount = 5
    
    lazy var networkService = {
        return RxSwift54GitHubNetworkService()
    }()
    
    func validateUsername(_ username: String) -> Observable<ValidationResult> {
        if username.isEmpty {
            return .just(.empty)
        }
        
        // 判断是否只含字母和数字
        if username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return .just(.failed(message: "用户名只能包含数字和字母"))
        }
        
        // 发起请求校验
        return networkService.usernameAvailable(username)
            .map{ available in
                if available {
                    return .ok(message: "用户名可用")
                } else{
                    return .failed(message: "用户名已存在")
                }
            }
            .startWith(.validating) //发请求前，先返回一个“正在检查”的验证结果
    }
    
    func validatePassword(_ password: String) -> ValidationResult {
        let numberOfCharacters = password.count
        
        if numberOfCharacters == 0 {
            return .empty
        }
        
        if numberOfCharacters < minPasswordCount {
            return .failed(message: "密码至少需要\(minPasswordCount)个字符")
        }
        
        return .ok(message: "密码有效")
    }
    
    //验证二次输入的密码
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult {
        //判断密码是否为空
        if repeatedPassword.count == 0 {
            return .empty
        }
        
        //判断两次输入的密码是否一致
        if repeatedPassword == password {
            return .ok(message: "密码有效")
        } else {
            return .failed(message: "两次输入的密码不一致")
        }
    }
}
