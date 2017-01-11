//
//  App.swift
//  Elm
//
//  Created by jinseo on 2016. 12. 19..
//  Copyright © 2016년 Riiid. All rights reserved.
//

import Foundation
import RxSwift

struct ToggleElmArchitectureLabel: ElmComponent {
    typealias Model = Bool

    enum Message {
        case showText
        case hideText
    }
    
    static var initModel: Model {
        return false
    }
    
    static func update(_ model: Model, with message: Message) -> Model {
        switch message {
        case .showText:
            return true
        case .hideText:
            return false
        }
    }
    
    static func view(from model: Model) -> ViewTree<Message> {
        return .stack([
            .label(model ? "The Elm Architecture" : "...."),
            .button("Tap to \(model ? "hide" : "show")", model ? Message.hideText : Message.showText)
            ])
    }
}

struct App: ElmComponent {
    typealias Model = (
        buttonClicked: Int,
        toggleComponents: [ToggleElmArchitectureLabel.Model]
    )
    
    enum Message {
        case resetCount
        case subMsg(ToggleElmArchitectureLabel.Message, Int)
    }
    
    static var initModel: (buttonClicked: Int, toggleComponents: [ToggleElmArchitectureLabel.Model]) {
        let componentInitial = ToggleElmArchitectureLabel.initModel
        return (0, [componentInitial, componentInitial, componentInitial])
    }
    
    static func update(_ model: (buttonClicked: Int, toggleComponents: [ToggleElmArchitectureLabel.Model]), with message: App.Message) -> (buttonClicked: Int, toggleComponents: [ToggleElmArchitectureLabel.Model]) {
        switch message {
        case .resetCount:
            return (0, model.toggleComponents.map { _ in (ToggleElmArchitectureLabel.initModel) })
            
        case .subMsg(let subMsg, let idx):
            var componentModels = model.toggleComponents
            componentModels[idx] = ToggleElmArchitectureLabel.update(componentModels[idx], with: subMsg)
            return (model.buttonClicked+1, componentModels)
        }
    }
    
    static func view(from model: (buttonClicked: Int, toggleComponents: [ToggleElmArchitectureLabel.Model])) -> ViewTree<App.Message> {
        let subDOMs = model.toggleComponents.map(ToggleElmArchitectureLabel.view)
            .enumerated()
            .map { idx, subdom in return subdom.map { Message.subMsg($0, idx) } }
        
        let numberOfShows = model.toggleComponents.filter { $0 }.count
        
        return .stack([
                .button("Reset count", .resetCount),
                .label("Clicked \(model.buttonClicked)"),
                .stack(subDOMs),
                .label("\(numberOfShows)/\(model.toggleComponents.count)개 표시 중")
            ])
    }
}
