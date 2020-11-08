//
//  MVCListViewController.swift
//  StudyDesignPattern
//
//  Created by Mephrine on 2020/10/25.
//

import UIKit

final class MVCListViewController: BaseListViewController {
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
  init(service: AppService) {
    self.service = service
  }
    
  required convenience init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
    
  // MARK: - LifeCycle
  override func viewDidLoad() {
      super.viewDidLoad()
  }
    
  // MARK: - UI
  override func initView() {
    super.initView()
    searchTableView.delegate = self
    searchTableView.dataSource = self
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
  func requestSearch(searchText: String, filterState: SearchFilter, sortState: SearchSort, _ completion: @escaping (SearchResult?)-> ()) {
//    return nil
    if (filterState == .blog) {
      return service.nonRxSearchService.fetchSearchBlog(searchText, sortState, page) { (response, error) in
        if let result = response {
          completion(result)
          return
        }
        completion(nil)
      }
    } else {
      return service.nonRxSearchService.fetchSearchCafe(searchText, sortState, page) { (response, error) in
        if let result = response {
          completion(result)
          return
        }
        completion(nil)
      }
    }
  }
    
  func searchText() {
    do {
      let searchText = searchBar.text?.trimSide ?? ""
      if searchText == recentlySearchWord || searchText.isEmpty { return }
      
      requestSearch(searchText: searchText, filterState: filterState, sortState: sortState) { [weak self] response in
        guard let self = self else { return }
        if (response?.items?.count ?? 0) > 0 {
          self.page += 1
          self.totalPage += response?.totalCount ?? 0
          if let searchWord =  self.searchBar.text {
            self.recentlySearchWord = searchWord
          }
          
          self.searchItems += response?.items ?? []
          self.noDataView.isHidden = self.searchItems.count > 0
          
          self.searchTableView.reloadData()
        }
      }
      
//        .compactMap {
//        }
//        .compactMap { $0.items }
//        .flatMap{ $0 }
      
    } catch let error {
      log.e("request api error : \(error.localizedDescription)")
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
    self.searchText()
  }
}

// MARK: - TapGesture Action
extension MVCListViewController {
  @objc func tapSearchButton() {
    clearListAndSearch()
  }
}

// MARK: - UISearchBarDelegate
extension MVCListViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    clearListAndSearch()
  }
}


// MARK: - UITableViewDelegate & UITableViewDataSource
extension MVCListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchItems.count
  }
    
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: MVCTableViewCell = tableView.dequeueReusableCell(for: indexPath)
    
    //indexPath
    let model = searchItems[indexPath.row]
    cell.configuration(model: model)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let model = searchItems[indexPath.row]
    let detailViewController = MVCDetailViewController(selectedModel: model)

    navigationController?.pushViewController(detailViewController, animated: true)
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if chkEnablePaging() {
      let lastSectionIndex = self.searchTableView.numberOfSections - 1
      let lastRowIndex = self.searchTableView.numberOfRows(inSection: lastSectionIndex) - 1
      if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
          searchText()
      }
    }
  }
}
