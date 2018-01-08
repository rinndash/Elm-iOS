//
//  Forms.swift
//  Elm
//
//  Created by 윤진서 on 2017. 8. 19..
//  Copyright © 2017년 Riiid. All rights reserved.
//

import Foundation
import UIKit

struct Forms: BeginnerProgram {
    struct Model: CopyableStruct {
        var name: String
        var password: String
        var passwordAgain: String
    }
    
    var model: Model { return Model(
        name: ""
        , password: ""
        , passwordAgain: ""
        )
    }
    
    enum Message {
        case name(String)
        case password(String)
        case passwordAgain(String)
    }
    
    func update(model: Forms.Model, with message: Forms.Message) -> Forms.Model {
        switch message {
        case let .name(name):
            return model.copy {
                $0.name = name
            }
            
        case let .password(password):
            return model.copy {
                $0.password = password
            }
            
        case let .passwordAgain(passwordAgain):
            return model.copy {
                $0.passwordAgain = passwordAgain
            }
        }
    }
    
    func view(model: Model) -> ViewModel<Message> {
        return stack(
            identity: "stack",
            [
                textField(identity: "nameTextField", placeholder: "Name", key:"nameTextField", onInput: Message.name),
                textField(identity: "passwordTextField", placeholder: "Password", key:"passwordTextField", onInput: Message.password),
                textField(identity: "passwerdAgainTextField", placeholder: "Re-enter Password", key:"passwordAgainTextField", onInput: Message.passwordAgain),
                viewValidation(model)
            ])
    }
    
    func viewValidation(_ model: Model) -> ViewModel<Message> {
        let arePasswordsMatch = model.password == model.passwordAgain
        let title = arePasswordsMatch ? "OK" : "Passwords do not match!"
        let color = arePasswordsMatch ? UIColor.green : UIColor.red
        return label(identity: "validationLabel", with: title, color: color)
    }
}
