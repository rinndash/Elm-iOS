//
//  Button.swift
//  Elm
//
//  Created by 윤진서 on 2017. 8. 10..
//  Copyright © 2017년 Riiid. All rights reserved.
//

import Foundation

struct Button: BeginnerProgram {
    typealias Model = Int
    
    let model: Model = 0
    
    enum Message {
        case increment
        case decrement
    }
    
    func update(model: Model, with message: Message) -> Int {
        switch message {
        case .increment:
            return model + 1
        case .decrement:
            return model - 1
        }
    }
    
    func view(model: Model) -> ViewModel<Message> {
        return label(identity: "label", with: model.description)
            
//            stack([
//            button(onTap: .decrement, "-"),
//            label(with: model.description),
//            button(onTap: .increment, "+")
//            ])
    }
}
