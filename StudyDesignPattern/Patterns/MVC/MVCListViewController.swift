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
  func requestSearch(searchText: String, filterState: SearchFilter, sortState: SearchSort) throws -> SearchResult? {
    if (filterState == .blog) {
      return try service.nonRxSearchService.fetchSearchBlog(searchText, sortState, page)
    } else {
      return try service.nonRxSearchService.fetchSearchCafe(searchText, sortState, page)
    }
  }
    
  func searchText() {
    do {
      let result = try searchBar.text?
        .compactMap{ String($0).trimSide }
        .filter { $0 != recentlySearchWord }
        .compactMap { try requestSearch(searchText: $0, filterState: filterState, sortState: sortState) }
        .compactMap { $0.items }
        .flatMap{ $0 }
      
      if (result?.count ?? 0) > 0 {
        page += 1
        recentlySearchWord = searchBar.text!
        searchItems += result!
        searchTableView.reloadData()
      }
    } catch let error {
      log.e("request api error : \(error.localizedDescription)")
    }
  }
    
  // MARK: - Override
  override func selectActionSort(selected: SearchSort) {
    sortState = selected
    page = 1
    searchText()
  }
  
  override func selectFilter(selected: SearchFilter) {
    filterState = selected
    page = 1
    searchText()
  }
}

// MARK: - TapGesture Action
extension MVCListViewController {
  @objc func tapSearchButton() {
    searchText()
  }
}

// MARK: - UISearchBarDelegate
extension MVCListViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchText()
  }
}


// MARK: - UITableViewDelegate & UITableViewDataSource
extension MVCListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchItems.count
  }
    
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? MVCTableViewCell else {
      return UITableViewCell()
    }
    
    let model = searchItems[indexPath.row]
    cell.configuration(model: model)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let model = searchItems[indexPath.row]
    let detailViewController = MVCDetailViewController(selectedModel: model)

    navigationController?.pushViewController(detailViewController, animated: true)
  }
}
