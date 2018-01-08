//
//  ViewController.swift
//  Elm
//
//  Created by jinseo on 2016. 12. 19..
//  Copyright © 2016년 Riiid. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        run(program: Button(), in: self)
            .disposed(by: disposeBag)
    }
}

