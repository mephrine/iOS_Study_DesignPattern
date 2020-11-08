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
  let reactorKitListReactor: ReactorKitListReactor
//  let reactorKitDetailReactor: ReactorKitDetailReactor
  let mvcListViewController: MVCListViewController
}

extension AppDependency {
  static func resolve() -> AppDependency {
    let searchService = SearchService()
    let nonRxSearchService = NonRxSearchService()
    let service = AppService(searchService: searchService, nonRxSearchService: nonRxSearchService)
    let reactorKitListReactor = ReactorKitListReactor(withService: service)
//    let reactorKitDetailReactor = ReactorKitDetailReactor(selectedModel: service, index: <#Int#>)
    let mvcListViewController = MVCListViewController(service: service)
    
    return AppDependency(searchService: searchService, nonRxSearchService: nonRxSearchService, service: service, reactorKitListReactor: reactorKitListReactor, mvcListViewController: mvcListViewController)
  }
    
}
