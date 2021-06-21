//
//  RxSwift54ViewController.swift
//  RxSwiftDemo
//
//  Created by Kystar's Mac Book Pro on 2021/6/19.
//

import UIKit
import RxCocoa
import RxSwift

class RxSwift54ViewController: BaseViewController {
    
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var userNameTipsLB: UILabel!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordTipsLB: UILabel!
    @IBOutlet weak var confirmPwdTF: UITextField!
    @IBOutlet weak var confirmPwdTipsLB: UILabel!
    @IBOutlet weak var signupBtn: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let viewModel = RxSwift54GithubSignupViewModel(input: (username: userNameTF.rx.text.orEmpty.asDriver(), password: passwordTF.rx.text.orEmpty.asDriver(), repeatedPassword:confirmPwdTF.rx.text.orEmpty.asDriver() , loginTaps: signupBtn.rx.tap.asSignal()), dependency: (networkService: RxSwift54GitHubNetworkService(), signupService: RxSwift54GitHubSignupService()))
        
        viewModel.validateUsername
            .drive(userNameTipsLB.rx.rx54ValidationResult)
            .disposed(by: disposeBag)
        
        viewModel.validatePassword
            .drive(passwordTipsLB.rx.rx54ValidationResult)
            .disposed(by: disposeBag)
        
        viewModel.validatedPasswordRepeated
            .drive(confirmPwdTipsLB.rx.rx54ValidationResult)
            .disposed(by: disposeBag)
        
        viewModel.signEnable
            .drive(onNext: { [weak self] valid in
                self?.signupBtn.isEnabled = valid
                self?.signupBtn.alpha = valid ? 1.0: 0.3
            })
            .disposed(by: disposeBag
            )
        
        viewModel.signupResult
            .drive(onNext: { [unowned self] result in
                self.showMessage("注册" + (result ? "成功" : "失败") + "!")
            })
            .disposed(by: disposeBag)
    }
    
    //详细提示框
    func showMessage(_ message: String) {
        let alertController = UIAlertController(title: nil,
                                                message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
