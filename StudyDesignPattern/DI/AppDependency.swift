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
}

extension AppDependency {
  static func resolve() -> AppDependency {
    let searchService = SearchService()
    let nonRxSearchService = NonRxSearchService()
    let service = AppService(searchService: searchService, nonRxSearchService: nonRxSearchService)
    let reactorKitListReactor = ReactorKitListReactor(withService: service)
//    let reactorKitDetailReactor = ReactorKitDetailReactor(selectedModel: service, index: <#Int#>)
    
    return AppDependency(searchService: searchService, nonRxSearchService: nonRxSearchService, service: service, reactorKitListReactor: reactorKitListReactor)
  }
    
}
