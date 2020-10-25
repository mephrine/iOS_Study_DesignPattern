//
//  SearchDetailViewModel.swift
//  SearchApp
//
//  Created by Mephrine on 2020/07/15.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import ReactorKit
import Foundation

final class SearchDetailViewModel: BaseViewModel, Reactor {
    var initialState = State()
    
    let model: SearchItem
    let index: Int
    
    init(selectedModel: SearchItem, index: Int) {
        self.model = selectedModel
        self.index = index
    }
    
    /**
     # (E) Action
     - Author: Mephrine
     - Date: 20.07.15
     - Note: ReactorKit에서 ViewController에서 실행될 Action을 모아둔 enum
     */
    enum Action {
        case loadView
    }
    
    /**
     # (E) Mutation
     - Author: Mephrine
     - Date: 20.07.15
     - Note: ReactorKit에서 Action이 들어오면 비즈니스 로직 처리 후 변경 값을 리턴하는 로직을 담당하는 Mutation함수에서 처리할 enum 모음
     */
    enum Mutation {
        case loadView
    }
    
    /**
     # (S) State
     - Author: Mephrine
     - Date: 20.07.15
     - Note: ReactorKit에서 상태값을 관리하는 구조체
     */
    struct State {
        var thumbnailURL: URL?
        var typeBGColor: UIColor = .clear
        var type: String = ""
        var name: String = ""
        var title: NSAttributedString?
        var contents: NSAttributedString?
        var dateTime: String = ""
        var url: String = ""
    }
    
    /**
     # mutate
     - Author: Mephrine
     - Date: 20.07.15
     - Parameters:
     - action: 실행된 action
     - Returns: Observable<Mutation>
     - Note: Action이 들어오면 해당 부분을 타고, Service와의 Side Effect 처리를 함. (API 통신 등.) 그리고 Mutaion으로 반환
     */
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadView:
            return Observable.just(.loadView)
        }
    }
    /**
     # reduce
     - Author: Mephrine
     - Date: 20.07.15
     - Parameters:
     - state: 이전 state
     - mutation: 변경된 mutation
     - Returns: Bool
     - Note: 이전의 상태값과 Mutation을 이용해서 새로운 상태값을 반환
     */
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .loadView:
            if let thumbnail = model.thumbnail {
                newState.thumbnailURL = URL(string: thumbnail)
            }
            newState.name = model.name ?? ""
            newState.title = model.title?.htmlAttributedString(font: Utils.Font(.Regular, size: 15))
            newState.contents = model.contents?.htmlAttributedString(font: Utils.Font(.Regular, size: 15))
            newState.dateTime = model.datetime?.toDateKr() ?? ""
            newState.url = model.url ?? ""
        }
        return newState
    }
    
    // MARK: Action
    func moveToWebPage() {
        steps.accept(AppStep.goWebpage(url: currentState.url, title: currentState.title?.string ?? ""))
    }
    
    @objc func goBack() {
        steps.accept(AppStep.goBackToSearchList(row: index))
    }
}
