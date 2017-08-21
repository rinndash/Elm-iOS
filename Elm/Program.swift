//
//  Program.swift
//  Elm
//
//  Created by 윤진서 on 2017. 8. 19..
//  Copyright © 2017년 Riiid. All rights reserved.
//

import Foundation
import RxSwift

struct Command<MSG> {
    let run: (() -> Any)?
    let transform: ((Any) -> MSG)?
    
    static var none: Command<MSG> {
        return Command(run: nil, transform: nil)
    }
}

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

//extension Program {
//    func main(sources: Observable<Message>) -> Observable<ViewModel<Message>> {
//        let initialModel: Model = model
//        let model$ = sources
//            .scan(initialModel, accumulator: update)
//            .startWith(initialModel)
//        let view$ = model$.map(view)
//        return view$
//    }
//}
