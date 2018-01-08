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
    let message$: Observable<Message>
    
    init<View: UIView>(_ f: (View) -> Observable<Message>) {
        message$ = Observable.empty()
    }
}

func stack<Message>(_ subviewModels: [ViewModel<Message>]) -> ViewModel<Message> {
    return ViewModel { (stackView: UIStackView) -> Observable<Message> in
        return Observable.empty()
    }
}

func textField<Message>(placeholder: String, key: String? = nil, onInput: @escaping (String) -> Message) -> ViewModel<Message> {
    return ViewModel { (stackView: UIStackView) -> Observable<Message> in
        return Observable.empty()
    }
}

func button<Message>(onTap: Message, _ title: String) -> ViewModel<Message> {
    return ViewModel { (stackView: UIStackView) -> Observable<Message> in
        return Observable.empty()
    }
}

func label<Message>(with text: String, color: UIColor? = nil) -> ViewModel<Message> {
    return ViewModel { (stackView: UIStackView) -> Observable<Message> in
        return Observable.empty()
    }
}
