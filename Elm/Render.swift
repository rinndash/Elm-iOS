//
//  Render.swift
//  Elm
//
//  Created by 윤진서 on 2017. 8. 19..
//  Copyright © 2017년 Riiid. All rights reserved.
//

import UIKit
import LayoutKit
import RxSwift

func render<Message>(_ viewTree: ViewModel<Message>, disposeBag: DisposeBag) -> (Layout, Observable<Message>) {
    let messageChannel: PublishSubject<Message> = PublishSubject()
    
    switch viewTree {
    case .label(let text):
        return (LabelLayout(text: text), messageChannel)
        
    case .button(let message, let title):
        return (ButtonLayout(
            type: .system
            , title: title
            , config: { (button) in
                button.rx.tap
                    .takeUntil(button.rx.deallocating)
                    .map { _ in message }
                    .bind(to: messageChannel)
                    .disposed(by: disposeBag)
        }), messageChannel)

    case let .textField(placeholder, onTextChange):
        return (SizeLayout<UITextField>(
            width: 300
            , height: 100
            , viewReuseId: "textfield"
            , config: { textField in
            textField.placeholder = placeholder
            textField.rx.value
                .takeUntil(textField.rx.deallocating)
                .flatMap { $0 == nil ? Observable.empty() : Observable.just($0!) }
                .distinctUntilChanged()
                .map(onTextChange)
                .bind(to: messageChannel)
                .disposed(by: disposeBag)
        }), messageChannel)
        
    case .stack(let subDOMs):
        let viewAndMessages = subDOMs.map { render($0, disposeBag: disposeBag) }
        let subLayouts = viewAndMessages.map { $0.0 }
        let message$ = Observable.from(viewAndMessages.map { $0.1 }).merge()
        message$.subscribe(messageChannel).disposed(by: disposeBag)
        return (StackLayout(
            axis: .vertical
            , spacing: 10
            , alignment: .center
            , flexibility: Flexibility.max
            , sublayouts: subLayouts)
        , messageChannel)
    }
}
