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
    case label(text: String)
    case textField(placeholder: String, onInput: (String) -> Message)
    case button(onTap: Message, title: String)
}

func stack<T>(_ subviewModels: [ViewModel<T>]) -> ViewModel<T> {
    return .stack(subviewModels: subviewModels)
}

func textField<T>(placeholder: String, onInput: @escaping (String) -> T) -> ViewModel<T> {
    return .textField(placeholder: placeholder, onInput: onInput)
}

func button<T>(onTap: T, _ title: String) -> ViewModel<T> {
    return .button(onTap: onTap, title: title)
}

func label<T>(with text: String) -> ViewModel<T> {
    return .label(text: text)
}

func render<Message>(from viewTree: ViewModel<Message>) -> (UIView, Observable<Message>) {
    switch viewTree {
    case .label(let text):
        let label = UILabel()
        label.textAlignment = .center
        label.text = text
        label.textColor = UIColor.darkText
        return (label, Observable.empty())
        
    case .button(let message, let title):
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        return (button, button.rx.tap
            .takeUntil(button.rx.deallocating)
            .map { _ in message }
        )
        
    case let .textField(placeholder, onTap):
        let textField = UITextField()
        textField.placeholder = placeholder
        return (textField, textField.rx.value
            .takeUntil(textField.rx.deallocating)
            .flatMap { $0 == nil
                ? Observable.empty()
                : Observable.just($0!)
            }
            .distinctUntilChanged { lhs, rhs in lhs == rhs }
            .map(onTap) 
        )
        
    case .stack(let subDOMs):
        let viewAndMessages = subDOMs.map(render)
        let subviews = viewAndMessages.map { $0.0 }
        let message$ = Observable.from(viewAndMessages.map { $0.1 }).merge()
        let stackView = UIStackView(arrangedSubviews: subviews)
        stackView.axis = .vertical
        stackView.spacing = 10
        return (stackView, message$)
    }
}
