//
//  NonRxSearchService.swift
//  StudyDesignPattern
//
//  Created by Mephrine on 2020/11/02.
//

import Foundation
import SwiftyJSON
import SwiftyUserDefaults

protocol HasNonRxSearchService {
    var nonRxSearchService: NonRxSearchService { get }
}

/**
 # (P) HasSearchService
 - Author: Mephrine
 - Date: 20.07.12
 - Note: 검색 관련 서비스 프로토콜에서 구현되는 항목
*/
protocol NonRxSearchServiceProtocol {
    func fetchSearchCafe(_ searchText: String, _ sort: SearchSort, _ page: Int) throws -> SearchResult?
    func fetchSearchBlog(_ searchText: String, _ sort: SearchSort, _ page: Int) throws -> SearchResult?
    func defaultSearchHistory() -> [String]?
}

open class NonRxSearchService: NonRxSearchServiceProtocol {
    private let networking = Networking()
    
    /**
     # fetchSearchCafe
     - Author: Mephrine
     - Date: 20.07.12
     - Parameters:
         - searchText : 검색할 텍스트
         - sort : 정렬 기준
         - page : 불러올 페이지
     - Returns: SearchResult
     - Note: 네트워크 통신을 통해 카페 검색 정보를 받아옴.
    */
  func fetchSearchCafe(_ searchText: String, _ sort: SearchSort, _ page: Int) throws -> SearchResult? {
        networking.session.cancelAllRequests()
        return try networking.request(.searchCafe(query: searchText, sort: sort.value, page: page))
          .map(SearchResult.self)
    }
    
    /**
     # fetchSearchBlog
     - Author: Mephrine
     - Date: 20.07.12
     - Parameters:
         - searchText : 검색할 텍스트
         - sort : 정렬 기준
         - page : 불러올 페이지
     - Returns: Single<SearchResult>
     - Note: 네트워크 통신을 통해 블로그 검색 정보를 받아옴.
    */
    func fetchSearchBlog(_ searchText: String, _ sort: SearchSort, _ page: Int) throws -> SearchResult? {
        networking.session.cancelAllRequests()
        return try networking.request(.searchBlog(query: searchText, sort: sort.value, page: page))
        .map(to: SearchResult.self)
    }
    
    /**
     # defaultSearchHistory
     - Author: Mephrine
     - Date: 20.07.14
     - Parameters:
     - Returns: Single<[String]?>
     - Note: UserDefault에 보관된 검색 히스토리
    */
    func defaultSearchHistory() -> [String]? {
        return Defaults.serachHistory
    }
    
    /**
     # defaultAddSearchHistory
     - Author: Mephrine
     - Date: 20.07.14
     - Parameters:
     - Returns: Single<[String]?>
     - Note: UserDefault에  검색 히스토리 더하기
    */
    func defaultAddSearchHistory(_ searchText: String) {
        // 중복 제거 및 더하기
        if var historyArray = Defaults.serachHistory {
            historyArray.append(searchText)
            let history = Set(historyArray)
            Defaults.serachHistory = Array(history)
        } else {
            Defaults.serachHistory = [searchText]
        }
    }
}
