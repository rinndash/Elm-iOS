//
//  Elm.swift
//  Elm
//
//  Created by jinseo on 2016. 12. 19..
//  Copyright © 2016년 Riiid. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

enum ViewTree<Message> {
    case label(String)
    case button(String, Message)
    case stack([ViewTree])
    
    func map<AnotherMessage>(_ f: (Message) -> AnotherMessage) -> ViewTree<AnotherMessage> {
        switch self {
        case .label(let text):
            return ViewTree<AnotherMessage>.label(text)
            
        case .button(let title, let sourceMsg):
            return ViewTree<AnotherMessage>.button(title, f(sourceMsg))
            
        case .stack(let subDOMs):
            let doms = subDOMs.map { $0.map(f) }
            return ViewTree<AnotherMessage>.stack(doms)
        }
    }
}

protocol ElmComponent {
    associatedtype Model
    associatedtype Message
    
    static var initModel: Model { get }
    static func component(sources: Observable<Message>) -> Observable<ViewTree<Message>>
    static func update(_ model: Model, with message: Message) -> Model
    static func view(from model: Model) -> ViewTree<Message>
}

extension ElmComponent {
    static func component(sources: Observable<Message>) -> Observable<ViewTree<Message>> {
        let initialModel = initModel
        
        let model$ = sources
            .scan(initialModel, accumulator: update)
            .startWith(initialModel)
        
        let view$ = model$.map(view)
        
        return view$
    }
}

func run<Component: ElmComponent>(_ app: Component.Type, _ viewController: UIViewController) {
    let proxy = PublishSubject<Component.Message>()
    let sinks = app.component(sources: proxy)
    
    _ = sinks
        .takeUntil(viewController.rx.deallocating)
        .map(render)
        .do(onNext: { (contentView, _) in
            viewController.view.subviews.forEach { $0.removeFromSuperview() }
            viewController.view.addSubview(contentView)
            contentView.snp.makeConstraints { $0.center.equalToSuperview() }
        })
        .flatMapLatest { $0.1 }
        .do(onNext: {
            print($0)
        })
        .bindTo(proxy)
}

func render<MSG>(from viewTree: ViewTree<MSG>) -> (UIView, Observable<MSG>) {
    switch viewTree {
    case .label(let text):
        let label = UILabel()
        label.textAlignment = .center
        label.text = text
        label.textColor = UIColor.darkText
        return (label, Observable.empty())
        
    case .button(let title, let msg):
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        return (button, button.rx.tap
            .takeUntil(button.rx.deallocating)
            .map { _ in msg }
        )
        
    case .stack(let subDOMs):
        let viewAndMessages = subDOMs.map(render)
        let subviews = viewAndMessages.map { $0.0 }
        let message$ = Observable.from(viewAndMessages.map { $0.1 }).merge()
        let stackView = UIStackView(arrangedSubviews: subviews)
        stackView.axis = .vertical
        stackView.spacing = 10
        return (stackView, message$)
    }
}
