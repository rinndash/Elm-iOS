//
//  RND.swift
//  Elm
//
//  Created by 윤진서 on 2017. 8. 19..
//  Copyright © 2017년 Riiid. All rights reserved.
//

import Foundation

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
    
    static func generate<A, Message, Generator: RandomGenerator>(transform: @escaping (A) -> Message, generator: Generator) -> Command<Message> where Generator.Value == A {
        let run: () -> Any = { generator.generate() }
        let t: (Any) -> Message = { (x: Any) -> Message in transform(x as! A) }
        return Command(run: run, transform: t)
    }
}
