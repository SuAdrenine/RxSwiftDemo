//
//  UILabelExtension.swift
//  RxSwiftDemo
//
//  Created by Kystar's Mac Book Pro on 2021/6/21.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UILabel {
    var rx54ValidationResult: Binder<ValidationResult> {
        return Binder(base) { label, res in
            label.textColor = res.textColor
            label.text = res.description
        }
    }
}
