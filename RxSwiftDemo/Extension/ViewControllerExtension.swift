//
//  ViewControllerExtension.swift
//  RxSwiftDemo
//
//  Created by Kystar's Mac Book Pro on 2021/3/22.
//

import UIKit

extension UIViewController {

    static func classFromString(_ className:String) -> UIViewController {
          //Swift中命名空间的概念
        var name = Bundle.main.object(forInfoDictionaryKey: "CFBundleExecutable") as? String
        name = name?.replacingOccurrences(of: "-", with: "_")
        let fullClassName = name! + "." + className
        guard let classType = NSClassFromString(fullClassName) as? UIViewController.Type  else{
            fatalError("转换失败")
        }
        return classType.init()
    }

}
