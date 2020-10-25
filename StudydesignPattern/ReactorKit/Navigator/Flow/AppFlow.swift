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
        let viewController = BaseNavigationController()
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
        case .goWebpage(let url, let title):
            return goWebPage(url: url, title: title)
        case .goSFSafari(let url):
            return goSFViewController(url: url)
        case .goShowTelNumber(let url):
            return goShowTelNumber(url: url)
        case .goBackToSearchList(let row):
            return goBackToSearchList(row: row)
        case .goBackToSearchDetail:
            return goBackToSearchDetail()
        case .returnDetailToList(let row):
            return returnDetailToList(row: row)
        default:
            return .none
        }
    }
    
    // 메인화면 띄우기.
    private func goSearchList() -> FlowContributors {
        let viewModel = SearchListViewModel(withService: service)
        let searchVC = SearchListViewController.instantiate(withViewModel: viewModel, storyBoardName: "Main")
        self.rootViewController.setViewControllers([searchVC], animated: false)
        
        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: searchVC, withNextStepper: viewModel))
    }
    
    // 상세화면 띄우기.
    private func goSearchDetail(model: SearchItem, row: Int) -> FlowContributors {
        let viewModel = SearchDetailViewModel(selectedModel: model, index: row)
        let detail = SearchDetailViewController.instantiate(withViewModel: viewModel, storyBoardName: "Main")
        detail.title = model.name
        rootViewController.setNavigationBarHidden(false, animated: true)
        
        self.rootViewController.pushViewController(detail, animated: true)
        
        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: detail, withNextStepper: viewModel))
    }
    
    private func goBackToSearchList(row: Int?) -> FlowContributors {
        rootViewController.setNavigationBarHidden(true, animated: true)
        self.rootViewController.popViewController(animated: true)
        if let readWebPageIndex = row {
            return .end(forwardToParentFlowWithStep: AppStep.returnDetailToList(row: readWebPageIndex))
        }
        return .none
    }
    
    private func returnDetailToList(row: Int) -> FlowContributors {
        if let searchList = self.rootViewController.viewControllers.last as? SearchListViewController {
            searchList.reactor?.action.onNext(.readWebpage(index: row))
        }
        return .none
    }
    
    // 웹뷰페이지 띄우기.
    private func goWebPage(url: String, title: String) -> FlowContributors {
        let viewModel = WebPageViewModel(url: url)
        let webPage = WebPageViewController.instantiate(withViewModel: viewModel, storyBoardName: "Main")
        webPage.navigationItem.backBarButtonItem?.title = nil
        webPage.title = title
        
        
        self.rootViewController.pushViewController(webPage, animated: true)
        
        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: webPage, withNextStepper: viewModel))
    }
    
    private func goBackToSearchDetail() -> FlowContributors {
        self.rootViewController.popViewController(animated: true)
        return .none
    }
    
    /**
     # goSFViewController
     - Author: Mephrine
     - Date: 20.07.15
     - Parameters:
     - url : String 타입 링크
     - Returns:
     - Note: SafariVC로 URL링크 실행.
     */
    private func goSFViewController(url: String) -> FlowContributors {
        if let loadUrl = URL(string: url) {
            let sfViewController = SFSafariViewController(url: loadUrl)
            rootViewController.visibleViewController?.present(sfViewController, animated: true)
        }
        return .none
    }
    
    /**
     # openTelNumber
     - Author: Mephrine
     - Date: 20.07.15
     - Parameters:
     - urlStr : String 타입 전화번호
     - cancelTitle : 좌측 버튼 텍스트
     - completeTitle : 우측 버튼 텍스트
     - Returns:
     - Note: 전화걸기 알럿 노출 및 전화걸기 Action.
     */
    private func goShowTelNumber(url: String, _ cancelTitle: String = "취소", _ completeTitle: String = "통화" ) -> FlowContributors {
        
        if #available(iOS 11.0, *) {
            Utils.openExternalLink(url: url)
        } else {
            if #available(iOS 10.0, *) {
                if let phoneNumber = url.split(separator: ":").last {
                    if let viewController = rootViewController.visibleViewController {
                        CommonAlert.showConfirm(vc: viewController, message: String(phoneNumber), cancelTitle: cancelTitle, completeTitle: completeTitle, nil) {
                            Utils.openExternalLink(url: url)
                        }
                    }
                }
            } else {
                Utils.openExternalLink(url: url)
            }
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

