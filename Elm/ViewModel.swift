//
//  ViewModel.swift
//  Elm
//
//  Created by 윤진서 on 2017. 8. 10..
//  Copyright © 2017년 Riiid. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum ViewModel<Message> {
    case stack(subviewModels: [ViewModel<Message>])
    case label(text: String, color: UIColor?)
    case textField(placeholder: String, key: String?, onInput: (String) -> Message)
    case button(onTap: Message, title: String)
}

func stack<T>(_ subviewModels: [ViewModel<T>]) -> ViewModel<T> {
    return .stack(subviewModels: subviewModels)
}

func textField<T>(placeholder: String, key: String? = nil, onInput: @escaping (String) -> T) -> ViewModel<T> {
    return .textField(placeholder: placeholder, key: key, onInput: onInput)
}

func button<T>(onTap: T, _ title: String) -> ViewModel<T> {
    return .button(onTap: onTap, title: title)
}

func label<T>(with text: String, color: UIColor? = nil) -> ViewModel<T> {
    return .label(text: text, color: color)
}
