//
//  Random.swift
//  Elm
//
//  Created by 윤진서 on 2017. 8. 19..
//  Copyright © 2017년 Riiid. All rights reserved.
//

import Foundation

struct Random: Program {
    struct Model: CopyableStruct {
        var dieFace: Int
    }
    
    enum Message {
        case roll
        case newFace(Int)
    }
    
    var initial: (Model, Command<Message>) {
        return (Model(dieFace: 1), Command.none)
    }
    
    func update(model: Model, with message: Message) -> (Model, Command<Message>) {
        switch message {
        case .roll:
            return (model, RND.generate(transform: Message.newFace, generator: RND.integer(min: 1, max: 6)))
            
        case let .newFace(val):
            return (model.copy {
                $0.dieFace = val
            }, Command.none)
        }
    }
    
    func subscriptions(model: Model) -> Subscription<Message> {
        return .none
    }
    
    func view(model: Model) -> ViewModel<Message> {
        return stack(
            identity: "stack",
            [
                label(identity: "label", with: model.dieFace.description),
                button(identity: "rollButton", onTap: Message.roll, "Roll")
            ])
    }
}
