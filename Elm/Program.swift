//
//  Program.swift
//  Elm
//
//  Created by 윤진서 on 2017. 8. 19..
//  Copyright © 2017년 Riiid. All rights reserved.
//

import UIKit
import RxSwift

enum Subscription<MSG> {
    case none
}

protocol Program {
    associatedtype Model
    associatedtype Message
    
    var initial: (Model, Command<Message>) { get }
    func update(model: Model, with message: Message) -> (Model, Command<Message>)
    func subscriptions(model: Model) -> Subscription<Message>
    func view(model: Model) -> ViewModel<Message>
}

extension Program {
    func main(message$: Observable<Message>) -> Observable<Effect<Message>> {
        let (initialModel, initialCommand) = initial
        let model_effects = message$
            .scan(initial) { model_effect, message -> (Model, Command<Message>) in
                let (model, _) = model_effect
                return self.update(model: model, with: message)
            }
            .share(replay: 1, scope: .forever)
        
        let model$ = model_effects.map { $0.0 }
            .startWith(initialModel)
        
        let viewModel$ = model$
            .map(view)
            .map(Effect.view)
        
        let anotherEffect$ = model_effects.map { $0.1 }
            .startWith(initialCommand)
            .map(Effect.command)
        
        return Observable.merge([
            viewModel$,
            anotherEffect$
            ])
    }
}

func run<T>(program: T, in viewController: UIViewController) -> Disposable where T: Program {
    let proxy = PublishSubject<T.Message>()
    let sinks = program.main(message$: proxy).debug()
    
    return sinks
        .flatMapLatest { viewModel -> Observable<T.Message> in
            return Observable.empty()
        }
        .bind(to: proxy)
}




