//
//  CopayableStruct.swift
//  Elm
//
//  Created by 윤진서 on 2017. 8. 19..
//  Copyright © 2017년 Riiid. All rights reserved.
//

import Foundation

protocol CopyableStruct {
    func copy(with transform: (inout Self) -> Void) -> Self
}

extension CopyableStruct {
    func copy(with transform: (inout Self) -> Void) -> Self {
        var copy = self
        transform(&copy)
        return copy
    }
}
