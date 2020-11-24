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
  func searchCafe(searchText: String, sort: SearchSort, page: Int) -> Observable<SearchResult> {
    return Single<SearchResult>.create { observer in
      if let dummy = SearchCafeDummy.jsonData {
        observer(.success(dummy))
      } else {
        observer(.error(APIError.noData))
      }
      return Disposables.create()
    }.asObservable()
  }
  
  func searchBlog(searchText: String, sort: SearchSort, page: Int) -> Observable<SearchResult> {
    return Single<SearchResult>.create { observer in
      if let dummy = SearchBlogDummy.jsonData {
        observer(.success(dummy))
      } else {
        observer(.error(APIError.noData))
      }
      return Disposables.create()
    }.asObservable()
  }
  
  func searchHistory() -> Observable<[String]?> {
    return Observable.just(Defaults.serachHistory)
  }
}
