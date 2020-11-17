//
//  ServiceStub.swift
//  StudyDesignPattern
//
//  Created by Mephrine on 2020/10/25.
//

import Foundation
import Moya
import Stubber
@testable import Pods_StudyDesignPattern

class NonRxSearchServiceStub: NonRxSearchServiceProtocol {
  func fetchSearchCafe(_ searchText: String, _ sort: SearchSort, _ page: Int, _ completion: @escaping (SearchResult?, MoyaError?) -> ()) {
    Stubber.invoke()
  }
  
  func fetchSearchBlog(_ searchText: String, _ sort: SearchSort, _ page: Int, _ completion: @escaping (SearchResult?, MoyaError?) -> ()) {
    
  }
  
  func defaultSearchHistory() -> [String]? {
    return ["search"]
  }
}
