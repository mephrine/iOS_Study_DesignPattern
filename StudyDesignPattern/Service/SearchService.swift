//
//  SearchService.swift
//  SearchApp
//
//  Created by Mephrine on 2020/07/12.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyUserDefaults

/**
 # (P) HasSearchService
 - Author: Mephrine
 - Date: 20.07.12
 - Note: 검색 관련 서비스 사용 시 채택해야하는 프로토콜
*/
protocol HasSearchService {
    var searchService: SearchService { get }
}

/**
 # (P) HasSearchService
 - Author: Mephrine
 - Date: 20.07.12
 - Note: 검색 관련 서비스 프로토콜에서 구현되는 항목
*/
protocol SearchServiceProtocol {
    func fetchSearchCafe(_ searchText: String, _ sort: SearchSort, _ page: Int) -> Single<SearchResult>
    func fetchSearchBlog(_ searchText: String, _ sort: SearchSort, _ page: Int) -> Single<SearchResult>
    func defaultSearchHistory() -> Single<[String]?>
}

open class SearchService: SearchServiceProtocol {
    private let networking = Networking()
    
    /**
     # fetchSearchCafe
     - Author: Mephrine
     - Date: 20.07.12
     - Parameters:
         - searchText : 검색할 텍스트
         - sort : 정렬 기준
         - page : 불러올 페이지
     - Returns: Single<SearchResult>
     - Note: 네트워크 통신을 통해 카페 검색 정보를 받아옴.
    */
    func fetchSearchCafe(_ searchText: String, _ sort: SearchSort, _ page: Int) -> Single<SearchResult> {
        networking.session.cancelAllRequests()
        return networking.rx.request(.searchCafe(query: searchText, sort: sort.value, page: page))
            .map(to: SearchResult.self)
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
    func fetchSearchBlog(_ searchText: String, _ sort: SearchSort, _ page: Int) -> Single<SearchResult> {
        networking.session.cancelAllRequests()
        return networking.rx.request(.searchBlog(query: searchText, sort: sort.value, page: page))
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
    func defaultSearchHistory() -> Single<[String]?> {
        return Single.just(Defaults.serachHistory)
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

extension SearchService: ReactiveCompatible {}

extension Reactive where Base: SearchService {
    /**
     # searchCafe
     - Author: Mephrine
     - Date: 20.07.12
     - Parameters:
        - searchText : 검색할 텍스트
        - sort : 정렬 기준
        - page : 불러올 페이지
     - Returns: Observable<SearchResult>
     - Note: 카페 검색 정보를 rx로 접근 가능하도록 확장한 함수.
    */
    func searchCafe(searchText: String, sort: SearchSort = .accuracy, page: Int) -> Observable<SearchResult> {
        return base.fetchSearchCafe(searchText, sort, page).asObservable()
    }
    
    /**
     # searchUser
     - Author: Mephrine
     - Date: 20.07.12
     - Parameters:
         - searchText : 검색할 텍스트
         - sort : 정렬 기준
         - page : 불러올 페이지
     - Returns: Observable<SearchResult>
     - Note: 블로그 검색 정보를 rx로 접근 가능하도록 확장한 함수.
    */
    func searchBlog(searchText: String, sort: SearchSort = .accuracy, page: Int) -> Observable<SearchResult> {
        return base.fetchSearchBlog(searchText, sort, page).asObservable()
    }
    
    /**
     # searchAll
     - Author: Mephrine
     - Date: 20.07.14
     - Parameters:
         - searchText : 검색할 텍스트
         - sort : 정렬 기준
         - page : 불러올 페이지
     - Returns: Observable<SearchResult>
     - Note: 카페, 블로그 검색 정보를 반환.
    */
//    func searchAll(searchText: String, sort: SearchSort = .accuracy, page: Int) -> Observable<SearchResult> {
//        let searchCafeObservable = searchCafe(searchText: searchText, sort: sort, page: page)
//        let searchBlogObservable = searchBlog(searchText: searchText, sort: sort, page: page)
//        
//        return Observable.zip(searchCafeObservable, searchBlogObservable) { Observable.of($0, $1) }
//            .flatMap{ $0 }
//    }
    
    /**
     # searchHistory
     - Author: Mephrine
     - Date: 20.07.14
     - Parameters:
     - Returns: Observable<[String]?>
     - Note: UserDefault에 보관된 검색 히스토리
    */
    func searchHistory() -> Observable<[String]?> {
        return base.defaultSearchHistory().asObservable()
    }
}



