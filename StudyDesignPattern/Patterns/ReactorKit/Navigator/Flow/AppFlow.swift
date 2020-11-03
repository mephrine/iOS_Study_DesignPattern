//
//  AppFlow.swift
//  SearchApp
//
//  Created by Mephrine on 2020/07/12.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import Foundation
import RxCocoa
import RxFlow
import RxSwift
import UIKit
import SafariServices

/**
 # (C) AppFlow
 - Author: Mephrine
 - Date: 20.07.12
 - Note: 메인화면 네비게이션 관리 Flow.
 */
class AppFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        viewController.setNavigationBarHidden(true, animated: false)
        return viewController
    }()
    
    private let service: AppService
    
    init(service: AppService) {
        self.service = service
    }
    
    deinit {
        log.d("deinit MainFlow")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .goSearchList:
            return goSearchList()
        case .goSearchDetail(let model, let row):
            return goSearchDetail(model: model, row: row)
        case .returnDetailToList(let row):
            return returnDetailToList(row: row)
        default:
            return .none
        }
    }
    
    // 메인화면 띄우기.
    private func goSearchList() -> FlowContributors {
      let reactor = AppDependency.resolve().reactorKitListReactor
        let searchVC = ReactorKitListViewController(reactor: reactor)
        self.rootViewController.setViewControllers([searchVC], animated: false)

        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: searchVC, withNextStepper: reactor))
    }

    // 상세화면 띄우기.
    private func goSearchDetail(model: SearchItem, row: Int) -> FlowContributors {
        let reatctor = ReactorKitDetailReactor(selectedModel: model, index: row)
        let detail = ReactorKitDetailViewController(reactor: reatctor)
        detail.title = model.name
        rootViewController.setNavigationBarHidden(false, animated: true)

        self.rootViewController.pushViewController(detail, animated: true)

        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: detail, withNextStepper: reatctor))
    }

    private func returnDetailToList(row: Int) -> FlowContributors {
        if let searchList = self.rootViewController.viewControllers.last as? ReactorKitListViewController {
            searchList.reactor?.action.onNext(.readWebpage(index: row))
        }
        return .none
    }
}

/**
 # (C) AppStepper
 - Author: Mephrine
 - Date: 20.07.12
 - Note: 첫 Flow 실행을 위한 Stepper
 */
class AppStepper: Stepper {
    let steps = PublishRelay<Step>()
    private let appService: AppService
    
    init(withService service: AppService) {
        self.appService = service
    }
    
    var initialStep: Step {
        return AppStep.goSearchList
    }
    
    // FlowCoordinator가 Flow에 기여하기 위해 청취할 준비가 되면 step을 한번 방출하는데 사용되어지는 callback.
    func readyToEmitSteps() {
        
    }
}

