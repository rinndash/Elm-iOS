//
//  Effect.swift
//  Elm
//
//  Created by 윤진서 on 2018. 1. 9..
//  Copyright © 2018년 Riiid. All rights reserved.
//

import UIKit
import RxSwift

protocol EffectType {
    associatedtype Message
    
    var message$: Observable<Message> { get }
}

enum Effect<Message> {
    case view(ViewModel<Message>)
    case command(Command<Message>)
}
