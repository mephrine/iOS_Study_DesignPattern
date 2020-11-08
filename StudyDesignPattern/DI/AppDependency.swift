//
//  AppDependency.swift
//  StudyDesignPattern
//
//  Created by Mephrine on 2020/11/03.
//

import Foundation
import Pure

struct AppDependency {
  let searchService: SearchService
  let nonRxSearchService: NonRxSearchService
  let service: AppService
  let nonRxService: NonRxAppService
  let reactorKitListReactor: ReactorKitListReactor
//  let reactorKitDetailReactor: ReactorKitDetailReactor
  let mvcListViewController: MVCListViewController
}

extension AppDependency {
  static func resolve() -> AppDependency {
    let searchService = SearchService()
    let nonRxSearchService = NonRxSearchService()
    let service = AppService(searchService: searchService)
    let nonRxService = NonRxAppService(nonRxSearchService: nonRxSearchService)
    let reactorKitListReactor = ReactorKitListReactor(withService: service)
//    let reactorKitDetailReactor = ReactorKitDetailReactor(selectedModel: service, index: <#Int#>)
    let mvcListViewController = MVCListViewController(service: nonRxService)
    
    return AppDependency(searchService: searchService, nonRxSearchService: nonRxSearchService, service: service, nonRxService: nonRxService, reactorKitListReactor: reactorKitListReactor, mvcListViewController: mvcListViewController)
  }
    
}
