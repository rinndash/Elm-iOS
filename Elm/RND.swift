//
//  RND.swift
//  Elm
//
//  Created by 윤진서 on 2017. 8. 19..
//  Copyright © 2017년 Riiid. All rights reserved.
//

import Foundation
import RxSwift

protocol RandomGenerator {
    associatedtype Value
    func generate() -> Value
}

struct IntGenerator: RandomGenerator {
    func generate() -> Int {
        return 1
    }
}

struct RND {
    static func integer(min: Int, max: Int) -> IntGenerator {
        return IntGenerator()
    }
    
    static func generate<T, Message, Generator: RandomGenerator>(transform: @escaping (T) -> Message, generator: Generator) -> Command<Message> where Generator.Value == T {
        let generate$ = Observable<T>.create { observer in
            observer.onNext(generator.generate())
            observer.onCompleted()
            return Disposables.create()
        }
        
        return Command(message$: generate$.map(transform))
    }
}
