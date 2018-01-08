//
//  Command.swift
//  Elm
//
//  Created by 윤진서 on 2018. 1. 9..
//  Copyright © 2018년 Riiid. All rights reserved.
//

import Foundation
import RxSwift

struct Command<Message>: EffectType {
    let message$: Observable<Message>
    
    static var none: Command<Message> {
        return Command(message$: Observable.empty())
    }
}
