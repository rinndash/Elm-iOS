//
//  BeginnerProgram.swift
//  Elm
//
//  Created by 윤진서 on 2017. 8. 10..
//  Copyright © 2017년 Riiid. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

protocol BeginnerProgram {
    associatedtype Model
    associatedtype Message
    
    var model: Model { get }
    func update(model: Model, with message: Message) -> Model
    func view(model: Model) -> ViewModel<Message>
}

extension BeginnerProgram {
    func main(sources: Observable<Message>) -> Observable<ViewModel<Message>> {
        let initialModel: Model = model
        let model$ = sources
            .scan(initialModel, accumulator: update)
            .startWith(initialModel)
        let view$ = model$.map(view)
        return view$
    }
}

func run<Program>(program: Program, in viewController: UIViewController) -> Disposable where Program: BeginnerProgram {
    let proxy = PublishSubject<Program.Message>()
    let viewModel$ = program.main(sources: proxy).debug()
    
    return viewModel$
        .flatMapLatest { viewModel -> Observable<Program.Message> in
            return Observable.empty()
        }
        .bind(to: proxy)
}
