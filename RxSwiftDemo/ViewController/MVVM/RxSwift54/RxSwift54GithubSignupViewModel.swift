//
//  RxSwift54GithubSignupViewModel.swift
//  RxSwiftDemo
//
//  Created by Kystar's Mac Book Pro on 2021/6/21.
//

import Foundation
import RxSwift
import RxCocoa

class RxSwift54GithubSignupViewModel {
    let validateUsername: Driver<ValidationResult>
    let validatePassword: Driver<ValidationResult>
    let validatedPasswordRepeated: Driver<ValidationResult>
    
    let signEnable: Driver<Bool>
    let signupResult: Driver<Bool>
    
    // 正在注册
    let isSignIning: Driver<Bool>
    
    init(
        input:(
            username: Driver<String>,
            password: Driver<String>,
            repeatedPassword: Driver<String>,
            loginTaps: Signal<Void>
        ),
        dependency:(
            networkService: RxSwift54GitHubNetworkService,
            signupService: RxSwift54GitHubSignupService
        )
    ) {
        validateUsername = input.username
            .flatMapLatest { username in
                return dependency.signupService.validateUsername(username).asDriver(onErrorJustReturn: .failed(message: "服务器发生错误"))
            }
        validatePassword = input.password
            .map { pwd in
                return dependency.signupService.validatePassword(pwd)
            }
        
        //重复输入密码验证
        validatedPasswordRepeated = Driver.combineLatest(
            input.password,
            input.repeatedPassword,
            resultSelector: dependency.signupService.validateRepeatedPassword)
        signEnable = Driver.combineLatest(validateUsername, validatePassword, validatedPasswordRepeated) { um, pwd, repwd in
            um.isValid && pwd.isValid && repwd.isValid
        }.distinctUntilChanged()
        
        let usernameAndPassword = Driver.combineLatest(input.username, input.password) {
            (username: $0, password: $1)
        }
        
        let activityIndicator = ActivityIndicator()
        isSignIning = activityIndicator.asDriver()
        
        signupResult = input.loginTaps.withLatestFrom(usernameAndPassword)
            .flatMapLatest { pair in
                return dependency.networkService.signup(pair.username, password: pair.password).trackActivity(activityIndicator).asDriver(onErrorJustReturn: false)
            }
        
        
    }
}


