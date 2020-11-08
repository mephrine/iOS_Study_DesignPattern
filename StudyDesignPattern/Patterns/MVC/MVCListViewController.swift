//
//  MVCListViewController.swift
//  StudyDesignPattern
//
//  Created by Mephrine on 2020/10/25.
//

import UIKit

final class MVCListViewController: BaseListViewController, SelectSortProtocol {
  // MARK: - Variable / Value
  var service: HasNonRxSearchService
  
  // 검색된 리스트
  var searchItems = [SearchItem]()

  // 최근 검색어
  var recentlySearchWord = ""
  
  // 페이징
  var page = 1
  var totalPage = PAGE_COUNT
    
  //상태 관리
  var filterState = SearchFilter.all
  var sortState = SearchSort.accuracy
    
  // MARK: - Constructor
  init(service: NonRxAppService) {
    self.service = service
  }
    
  required convenience init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
    
  // MARK: - LifeCycle
  override func viewDidLoad() {
      super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(noti:)), name: UIResponder.keyboardWillShowNotification , object:nil)

    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(noti:)), name: UIResponder.keyboardWillHideNotification , object:nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
    NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
  }
    
  // MARK: - UI
  override func initView() {
    super.initView()
    searchTableView.delegate = self
    searchTableView.dataSource = self
    
    historyTableView.delegate = self
    historyTableView.dataSource = self
    searchTableView.register(cellType: MVCTableViewCell.self)
    
    searchBar.delegate = self
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapSearchButton))
    searchButton.addGestureRecognizer(tapGesture)
  }
    
  // MARK: - Request API
  /**
    # requestSearch
    - Author: Mephrine
    - Date: 20.11.01
    - Parameters: searchText
    - Note: 검색하기
    */
  func requestSearch(searchText: String, filterState: SearchFilter, sortState: SearchSort, _ completion: @escaping ([SearchItem]?)-> ()) {
    // Blog
    if (filterState == .blog) {
      return service.searchService.fetchSearchBlog(searchText, sortState, page) { (response, error) in
        if let result = response {
          self.page += 1
          self.totalPage += response?.totalCount ?? 0
          completion(result.items)
          return
        }
        completion(nil)
      }
    }
    // Cafe
    else if (filterState == .cafe) {
      return service.searchService.fetchSearchCafe(searchText, sortState, page) { (response, error) in
        if let result = response {
          self.page += 1
          self.totalPage += response?.totalCount ?? 0
          completion(result.items)
          return
        }
        completion(nil)
      }
    }
    // ALL
    else {
      let group = DispatchGroup()
      let queue = DispatchQueue.global(qos: .utility)
      var searchBlogResult: SearchResult? = nil
      var searchCafeResult: SearchResult? = nil
      var totalPage = 1
      
      group.enter()
        queue.async(group: group) { [weak self] in
            guard let self = self else { return }
            self.service.searchService.fetchSearchBlog(searchText, sortState, self.page) { (response, error) in
              if let result = response {
                searchBlogResult = result
              }
              group.leave()
            }
        }
        
      group.enter()
        queue.async(group: group) { [weak self] in
            guard let self = self else { return }
            self.service.searchService.fetchSearchCafe(searchText, sortState, self.page) { (response, error) in
              if let result = response {
                searchCafeResult = result
              }
              group.leave()
            }
        }

      group.notify(queue: queue) {
        totalPage = (searchBlogResult?.totalCount ?? 0) + (searchCafeResult?.totalCount ?? 0)
          
        self.totalPage = min(totalPage, PAGE_COUNT * 2)
          
        let sortedList = (sortState == .accuracy) ?
        self.divideSortText(list: (searchBlogResult?.items ?? []) , list2: (searchCafeResult?.items ?? [])) :
        self.divideSortDateTime(list: (searchBlogResult?.items ?? []) , list2: (searchCafeResult?.items ?? []))
          
        completion(sortedList)
      }
    }
  }
    
  func searchText() {
    let searchText = searchBar.text?.trimSide ?? ""
    if searchText.isEmpty { return }
      
    requestSearch(searchText: searchText, filterState: filterState, sortState: sortState) { [weak self] response in
      guard let self = self else { return }
      if (response?.count ?? 0) > 0 {
        Async.main {
          if let searchWord =  self.searchBar.text {
            self.recentlySearchWord = searchWord
          }
            
          self.searchItems += response ?? []
          self.noDataView.isHidden = self.searchItems.count > 0
            
          self.searchTableView.reloadData()
        }
      }
    }
  }
    
  // MARK: - Override
  override func selectActionSort(selected: SearchSort) {
    sortState = selected
    clearListAndSearch()
  }
  
  override func selectFilter(selected: SearchFilter) {
    filterState = selected
    clearListAndSearch()
  }
  
  // MARK: - User Functions
  func chkEnablePaging() -> Bool {
    if (page - 1) * PAGE_COUNT < totalPage {
        return true
    }
    return false
  }
  
  func clearListAndSearch() {
    self.page = 1
    self.totalPage = PAGE_COUNT
    self.searchItems.removeAll()
    self.recentlySearchWord = ""
    self.searchText()
  }
  
  /**
   # sortText
   - Author: Mephrine
   - Date: 20.07.13
   - Parameters:
   -str1 : 정렬 String1
   -str2 : 정렬 String2
   - Returns: Bool
   - Note: sorted 고차함수를 통한 텍스트 순으로 정렬을 위한 함수
   */
  func sortText(str1: String, str2: String) -> Bool {
      var compared: Bool = false
      //두 문자열 비교전 2개 중에 작은 길이가 기준 길이
      let limit = min(str1.count, str2.count)
      let arr1: [Character] = str1.map { $0 }
      let arr2: [Character] = str2.map { $0 }
      for idx in 0 ..< limit {
          if arr1[idx] == arr2[idx] {
              continue
          } else {
              compared = arr1[idx] > arr2[idx]
              break
          }
      }
      return compared
  }

  /**
   # sortDateTime
   - Author: Mephrine
   - Date: 20.07.13
   - Parameters:
   -str1 : 정렬 String1
   -str2 : 정렬 String2
   - Returns: Bool
   - Note: sorted 고차함수를 통한 날짜 순으로 정렬을 위한 함수
   */
  func sortDateTime(str1: String, str2: String) -> Bool {
    var compared: Bool = false
    //두 문자열 비교전 2개 중에 작은 길이가 기준 길이
    let limit = min(str1.count, str2.count)
    let arr1: [Character] = str1.map { $0 }
    let arr2: [Character] = str2.map { $0 }
    for idx in 0 ..< limit {
      if arr1[idx] == arr2[idx] {
        continue
      } else {
        compared = arr1[idx] > arr2[idx]
        break
      }
    }
    return compared
  }
  
  /**
   # divideSortText
   - Author: Mephrine
   - Date: 20.07.13
   - Parameters:
   -list : 분할정렬할 list
   -list2 : 분할정렬할 list2
   - Returns: [SearchItem]
   - Note: allList와 분할정렬해서 반환
   */
  func divideSortText(list: [SearchItem], list2: [SearchItem]) -> [SearchItem] {
    var index1: Int = 0
    var index2: Int = 0
    var sortedAllList = [SearchItem]()
    while index1 < list.count && index2 < list2.count {
      if sortText(str1: list[index1].title, str2: list2[index2].title) {
        sortedAllList.append(list[index1])
        index1 += 1
      } else {
        sortedAllList.append(list2[index2])
        index2 += 1
      }
    }

    // 남은 반대쪽 데이터 append
    for i in index1 ..< list.count {
      sortedAllList.append(list[i])
    }

    for i in index2 ..< list2.count {
      sortedAllList.append(list2[i])
    }

    return sortedAllList
  }

  /**
   # divideSortDateTime
   - Author: Mephrine
   - Date: 20.07.13
   - Parameters:
   -list : 분할정렬할 list
   -list2 : 분할정렬할 list2
   - Returns: [SearchItem]
   - Note: allList와 분할정렬해서 반환
   */
  func divideSortDateTime(list: [SearchItem], list2: [SearchItem]) -> [SearchItem] {
    var index1: Int = 0
    var index2: Int = 0
    var sortedAllList = [SearchItem]()
    while index1 < list.count && index2 < list2.count {
      if sortDateTime(str1: list[index1].datetime, str2: list2[index2].datetime) {
        sortedAllList.append(list[index1])
        index1 += 1
      } else {
        sortedAllList.append(list2[index2])
        index2 += 1
      }
    }

    // 남은 반대쪽 데이터 append
    for i in index1 ..< list.count {
      sortedAllList.append(list[i])
    }

    for i in index2 ..< list2.count {
      sortedAllList.append(list2[i])
    }

    return sortedAllList
  }
}

// MARK: - Action
extension MVCListViewController {
  @objc func tapSearchButton() {
    searchAction()
  }
  
  func searchAction() {
    let searchText = searchBar.text?.trimSide ?? ""
    if searchText == recentlySearchWord || searchText.isEmpty { return }
    clearListAndSearch()
  }
  
  @objc func keyboardWillShow(noti: NSNotification) {
    manageHistoryView(true)
  }

  @objc func keyboardWillHide(noti: NSNotification) {
    manageHistoryView(false)
  }
}

// MARK: - UISearchBarDelegate
extension MVCListViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchAction()
  }
}


// MARK: - UITableViewDelegate & UITableViewDataSource
extension MVCListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView === searchTableView {
      return searchItems.count
    } else {
      return service.searchService.defaultSearchHistory()?.count ?? 0
    }
  }
    
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if tableView === searchTableView {
   
      let cell: MVCTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      
      //indexPath
      let model = searchItems[indexPath.row]
      cell.configuration(model: model)
      
      return cell
    } else {
      let cell: SearchHistoryCell = tableView.dequeueReusableCell(for: indexPath)
      
      //indexPath
      if let model = service.searchService.defaultSearchHistory()?[indexPath.row] {
        cell.configure(item: model)
      }
      
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if tableView === searchTableView {
      let model = searchItems[indexPath.row]
      let detailViewController = MVCDetailViewController(selectedModel: model)

      navigationController?.pushViewController(detailViewController, animated: true)
    } else {
      if let model = service.searchService.defaultSearchHistory()?[indexPath.row] {
        searchBar.text = model
        clearListAndSearch()
      }
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if tableView === searchTableView {
      if chkEnablePaging() {
        let lastSectionIndex = self.searchTableView.numberOfSections - 1
        let lastRowIndex = self.searchTableView.numberOfRows(inSection: lastSectionIndex) - 1
        log.d("test1 : \(indexPath.section ==  lastSectionIndex)")
        log.d("test2 : \(indexPath.row == lastRowIndex)")
        if (indexPath.section ==  lastSectionIndex) && (indexPath.row == lastRowIndex) {
            searchText()
        }
      }
    }
  }
}
