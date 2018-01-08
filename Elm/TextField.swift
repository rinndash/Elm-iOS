//
//  TextField.swift
//  Elm
//
//  Created by 윤진서 on 2017. 8. 10..
//  Copyright © 2017년 Riiid. All rights reserved.
//

import Foundation

struct TextField: BeginnerProgram {
    struct Model {
        let content: String
    }
    
    var model: TextField.Model { return Model(content: "") }
    
    enum Message {
        case change(String)
    }
    
    func update(model: TextField.Model, with message: TextField.Message) -> TextField.Model {
        switch message {
        case let .change(newContent):
            return Model(content: newContent)
        }
    }
    
    func view(model: TextField.Model) -> ViewModel<TextField.Message> {
        return stack(
            identity: "stack",
            [
                textField(identity: "textField", placeholder: "Text to reverse", onInput: Message.change),
                label(identity: "label", with: String(model.content.reversed()))
            ])
    }
}
