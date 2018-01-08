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

struct ViewModel<Message>: EffectType {
    let identity: String
    let subviewModels: [ViewModel<Message>]
    
    let message$: Observable<Message>
    
    static var none: ViewModel<Message> {
        return ViewModel(
            identity: "",
            subviewModels: [],
            message$: Observable.empty()
        )
    }
}

extension ViewModel {
    init<View: UIView>(identity: String, subviewModels: [ViewModel<Message>], _ f: (View) -> Observable<Message>) {
        self.identity = identity
        self.subviewModels = subviewModels
        message$ = Observable.empty()
    }
}

func stack<Message>(identity: String, _ subviewModels: [ViewModel<Message>]) -> ViewModel<Message> {
    return ViewModel(identity: identity, subviewModels: subviewModels) { (stackView: UIStackView) -> Observable<Message> in
        return Observable.empty()
    }
}

func textField<Message>(identity: String, placeholder: String, key: String? = nil, onInput: @escaping (String) -> Message) -> ViewModel<Message> {
    return ViewModel(identity: identity, subviewModels: []) { (stackView: UIStackView) -> Observable<Message> in
        return Observable.empty()
    }
}

func button<Message>(identity: String, onTap: Message, _ title: String) -> ViewModel<Message> {
    return ViewModel(identity: identity, subviewModels: []) { (stackView: UIStackView) -> Observable<Message> in
        return Observable.empty()
    }
}

func label<Message>(identity: String, with text: String, color: UIColor? = nil) -> ViewModel<Message> {
    return ViewModel(identity: identity, subviewModels: []) { (stackView: UIStackView) -> Observable<Message> in
        return Observable.empty()
    }
}
