//
//  SearchServiceStub.swift
//  StudyDesignPatternTests
//
//  Created by Mephrine on 2020/11/09.
//

import Foundation
import RxSwift
import SwiftyUserDefaults
@testable import StudyDesignPattern

struct SearchServiceStub: SearchServiceProtocol {
  func defaultSearchHistory() -> Single<[String]?> {
    return Single.just(Defaults.serachHistory)
  }
  
  func fetchSearchCafe(_ searchText: String, _ sort: SearchSort, _ page: Int) -> Single<SearchResult> {
    return Single<SearchResult>.create { observer in
      if let dummy = SearchCafeDummy.jsonData {
        observer(.success(dummy))
      } else {
        observer(.error(APIError.noData))
      }
      return Disposables.create()
    }
  }
  
  func fetchSearchBlog(_ searchText: String, _ sort: SearchSort, _ page: Int) -> Single<SearchResult> {
    return Single<SearchResult>.create { observer in
      if let dummy = SearchBlogDummy.jsonData {
        observer(.success(dummy))
      } else {
        observer(.error(APIError.noData))
      }
      return Disposables.create()
    }
  }
}
