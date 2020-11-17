//
//  BaseListViewController.swift
//  StudyDesignPattern
//
//  Created by Mephrine on 2020/11/01.
//

import UIKit

/**
 # (E) SearchFilter
 - Author: Mephrine
 - Date: 20.07.12
 - Note: SearchFilter 모음
 */
enum SearchFilter: String {
    case all = "All"
    case blog = "Blog"
    case cafe = "Cafe"
    
    var desc: String {
        switch self {
        case .all:
            return "All"
        case .blog:
            return "Blog"
        case .cafe:
            return "Cafe"
        }
    }
    
    var index: Int {
        switch self {
        case .all:
            return 0
        case .blog:
            return 1
        case .cafe:
            return 2
        }
    }
}

/**
 # (E) SearchSort
 - Author: Mephrine
 - Date: 20.07.12
 - Note: 검색 정렬 방식
 */
enum SearchSort: String {
    case accuracy = "Title"
    case recency = "Datetime"
    
    var value: String {
        switch self {
        case .recency:
            return "recency"
        default:
            return "accuracy"
        }
    }
}

protocol SelectSortProtocol: AnyObject {
    func selectActionSort(selected: SearchSort)
    func selectFilter(selected: SearchFilter)
}


class BaseListViewController: BaseViewController {
    // Gesture
    lazy var touchSuperViewGesture = TouchDownGestureRecognizer(target: self, action: #selector(hideFilterView))
  
  fileprivate struct Metric {
    static var filterButtonHorizontalEdge: CGFloat = 20.0
    static var filterStackViewVeritcalEdge: CGFloat = 5.0
    static var filterStackViewHorizontalEdge: CGFloat = 15.0
    
    static var searchButtonEdge: CGFloat = 10.0
    
    static var historyVerticalEdge: CGFloat = 5.0
    
    static var sortButtonEdge: CGFloat = 10
  }
  
  fileprivate struct Font {
    static let buttonTitle = UIFont.boldSystemFont(ofSize: 18)
    static let noDataTitle = UIFont.boldSystemFont(ofSize: 15)
  }
    
  fileprivate struct Color {
    static let bgColor = UIColor(hex: 0x666666)
    static let searchBgColor = UIColor(hex: 0x86a4e7)
    static let historyBgColor = UIColor(hex: 0x000000, alpha: 0.7)
  }
  
    // MARK: - View
    // searchBar
    let searchBar = UISearchBar(frame: .zero).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "STR_SEARCH_PLACE_HOLDER".localized
        $0.searchBarStyle = .prominent
        $0.sizeToFit()
        $0.isTranslucent = false
        
        if #available(iOS 13.0, *) {
            $0.setShowsScope(true, animated: true)
        }
    }
    
    let searchButton = UIButton(frame: .zero).then {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.backgroundColor = Color.searchBgColor
        $0.setTitleColor(.white, for: .normal)
      $0.titleLabel?.font = Font.buttonTitle
        $0.setTitle("STR_SEARCH_BUTTON".localized, for: .normal)
      $0.contentEdgeInsets = UIEdgeInsets(top: Metric.searchButtonEdge, left: Metric.searchButtonEdge, bottom: Metric.searchButtonEdge, right: Metric.searchButtonEdge)
    }
    
    // history
    lazy var historyTableView = UITableView(frame: .zero, style: .plain).then {
      $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(cellType: SearchHistoryCell.self)
      $0.contentInset = UIEdgeInsets(top: Metric.historyVerticalEdge, left: 0, bottom: Metric.historyVerticalEdge, right: 0)
        $0.rowHeight = 40
        $0.separatorStyle = .none
        $0.backgroundColor = .white
        if #available(iOS 11.0, *) {
            $0.contentInsetAdjustmentBehavior = .never
        }
    }
    
    lazy var historyView = UIView(frame: .zero).then {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.backgroundColor = Color.historyBgColor
    }
    
    // headerView
    let headerView = UIView(frame: .zero).then {
      $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
    }
    
    let filterButton = UIButton(frame: .zero).then {
      $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.setTitleColor(.black, for: .normal)
        $0.contentHorizontalAlignment = .left
      $0.titleLabel?.font = Font.buttonTitle
        $0.setTitle(SearchFilter.all.desc, for: .normal)
      $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: Metric.filterButtonHorizontalEdge, bottom: 0, right: Metric.filterButtonHorizontalEdge)
    }
    
    // filter view
    lazy var filterStackView = UIStackView(frame: .zero).then {
      $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 0
        $0.backgroundColor = .white
      $0.layoutMargins = UIEdgeInsets(top: Metric.filterStackViewVeritcalEdge, left: Metric.filterStackViewHorizontalEdge, bottom: Metric.filterStackViewVeritcalEdge, right: Metric.filterStackViewHorizontalEdge)
        
        let lineView = UIView(frame: .zero).then {
          $0.translatesAutoresizingMaskIntoConstraints = false
          $0.backgroundColor = Color.bgColor
        }
        
        let lineView2 = UIView(frame: .zero).then {
          $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = Color.bgColor
        }
        
        let filterButton1 = UIButton(frame: .zero).then {
          $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .white
            $0.setTitleColor(.black, for: .normal)
            $0.contentHorizontalAlignment = .left
          $0.titleLabel?.font = Font.buttonTitle
            $0.setTitle(SearchFilter.blog.desc, for: .normal)
          $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: Metric.filterButtonHorizontalEdge, bottom: 0, right: Metric.filterButtonHorizontalEdge)
            $0.tag = 901
            
            let tapFilterGesture = UITapGestureRecognizer(target: self, action: #selector(selectFilterView(_:)))
            
            $0.addGestureRecognizer(tapFilterGesture)
        }
        
        let filterButton2 = UIButton(frame: .zero).then {
          $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .white
            $0.setTitleColor(.black, for: .normal)
            $0.contentHorizontalAlignment = .left
          $0.titleLabel?.font = Font.buttonTitle
            $0.setTitle(SearchFilter.cafe.desc, for: .normal)
            $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: Metric.filterButtonHorizontalEdge, bottom: 0, right: Metric.filterButtonHorizontalEdge)
            $0.tag = 902
            
            let tapFilterGesture = UITapGestureRecognizer(target: self, action: #selector(selectFilterView(_:)))
            $0.addGestureRecognizer(tapFilterGesture)
        }
        
        lineView.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        lineView2.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        filterButton1.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        filterButton2.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        $0.addArrangedSubview(filterButton1)
        $0.addArrangedSubview(lineView)
        $0.addArrangedSubview(filterButton2)
        $0.addArrangedSubview(lineView2)
    }
    
    // sort
    let sortButton = UIButton(frame: .zero).then {
      $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.setImage(UIImage(named: "icon_search_filter"), for: .normal)
      $0.contentEdgeInsets = UIEdgeInsets(top: Metric.sortButtonEdge, left: Metric.sortButtonEdge, bottom: Metric.sortButtonEdge, right: Metric.sortButtonEdge)
    }
    
    lazy var sortActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet).then {
        $0.addAction(UIAlertAction(title: SearchSort.accuracy.rawValue, style: .default, handler: { result in
            selectActionSort(selected: SearchSort.accuracy)
        }))
        $0.addAction(UIAlertAction(title: SearchSort.recency.rawValue, style: .default, handler: { result in
            selectActionSort(selected: SearchSort.recency)
        }))
        
        $0.addAction(UIAlertAction(title: "STR_CANCEL".localized, style: .cancel, handler: nil))
    }
    
    let headerBottomLineView = UIView(frame: .zero).then {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.backgroundColor = Color.bgColor
    }
    
    // tableview
    lazy var searchTableView = UITableView(frame: .zero, style: .plain).then {
      $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.rowHeight = 115
        $0.separatorStyle = .none
        $0.backgroundColor = .white
        $0.keyboardDismissMode = .onDrag
        if #available(iOS 11.0, *) {
            $0.contentInsetAdjustmentBehavior = .never
        }
    }
    
    // No Data
    let noDataView = UIView(frame: .zero).then {
      $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
    }
    
    let noDataLabel = UILabel(frame: .zero).then {
      $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.textColor = .black
        $0.text = "STR_SEARCH_NO_INPUT".localized
      $0.font = Font.noDataTitle
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    lazy var loadingView =  UIActivityIndicatorView(style: .gray).then {
      $0.translatesAutoresizingMaskIntoConstraints = false
        $0.frame = CGRect(x: 0, y: 0, width: searchTableView.bounds.width, height: 44)
    }
    
    // MARK: - Override Fucntion
    /**
     # initView
     - Author: Mephrine
     - Date: 20.07.12
     - Parameters:
     - Returns:
     - Note: ViewController에서 view 초기화 시에 실행할 내용 정의하는 Override용 함수
    */
    //MARK: - UI
    override func initView() {
      view.backgroundColor = .white
        // search Bar
        view.addSubview(searchBar)
        view.addSubview(searchButton)
        //navi
//        let searchButtonItem = UIBarButtonItem.init(customView: self.searchButton)
//        navigationItem.rightBarButtonItem = searchButtonItem
//
//        let searchBarItem = UIBarButtonItem.init(customView: searchBar)
//        navigationItem.leftBarButtonItem = searchBarItem
        
        
        // tableView
        view.addSubview(searchTableView)
        
        // tablewView HeaderView
        searchTableView.addSubview(headerView)
        searchTableView.tableHeaderView = headerView
        headerView.addSubview(filterButton)
        headerView.addSubview(sortButton)
        headerView.addSubview(headerBottomLineView)
        
        // noData View
        view.addSubview(noDataView)
        noDataView.addSubview(noDataLabel)
        
        // Gesture
        let tapSortGesture = UITapGestureRecognizer(target: self, action: #selector(showSortActionSheet))
        sortButton.addGestureRecognizer(tapSortGesture)
        
        // 필터뷰 버튼 클릭
        let tapFilterGesture = UITapGestureRecognizer(target: self, action: #selector(showFilterView))
        filterButton.addGestureRecognizer(tapFilterGesture)
      
      Async.main(after: 0.6) { [weak self] in
        self?.searchBar.becomeFirstResponder()
      }
    }
    
    /**
     # constraints
     - Author: Mephrine
     - Date: 20.07.12
     - Parameters:
     - Returns:
     - Note: 오토레이아웃 적용
     */
    override func constraints() {
        // search Bar
        searchBar.snp.makeConstraints {
            if #available(iOS 11.0, *) {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                $0.top.equalTo(topLayoutGuide.snp.bottom)
            }
            $0.left.equalToSuperview()
            $0.height.equalTo(searchBar.bounds.height)
        }

        searchButton.snp.makeConstraints {
            $0.centerY.equalTo(searchBar.snp.centerY)
            $0.left.equalTo(searchBar.snp.right)
            $0.right.equalToSuperview().offset(-10)
        }
        
        // tableView
        searchTableView.snp.makeConstraints{
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(searchBar.snp.bottom)
        }
        
        
        headerView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(40)
        }
        // tablewView HeaderView
        filterButton.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
            $0.right.equalTo(sortButton.snp.left).offset(-10)
        }
        filterButton.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 749), for: .horizontal)
        filterButton.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .horizontal)
        
        sortButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
            $0.width.height.equalTo(headerView.snp.height)
        }
        //        sortButton.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751), for: .horizontal)
        //        sortButton.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        
        headerBottomLineView.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        // noData View
        noDataLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview().offset(-40)
        }
        
        noDataView.snp.makeConstraints {
            $0.left.equalTo(searchTableView.snp.left)
            $0.right.equalTo(searchTableView.snp.right)
            $0.bottom.equalTo(searchTableView.snp.bottom)
            $0.top.equalTo(searchTableView.snp.top)
        }
        
        // history View
        historyView.addSubview(historyTableView)
        historyView.snp.makeConstraints {
            $0.height.lessThanOrEqualTo(125)
        }
        historyTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
  
  /**
   # manageHistoryView
   - Author: Mephrine
   - Date: 20.07.12
   - Parameters:
   - Returns:
   - Note: 히스토리 뷰 숨김 처리 관리
   */
  func manageHistoryView(_ isShowing: Bool) {
      if isShowing {
          var isExist = false
          for view in view.subviews {
              if view == historyView {
                  isExist = true
                  return
              }
          }
          if !isExist {
              view.addSubview(historyView)
              historyView.snp.makeConstraints { [weak self] in
                  guard let self = self else { return }
                  $0.top.equalTo(searchBar.snp.bottom)
                  $0.left.right.equalToSuperview()
                  $0.height.lessThanOrEqualTo(250)
              }
          }
          
          historyView.alpha = 0
          view.layoutIfNeeded()
          
          UIView.animate(withDuration: 0.3) {
              historyView.alpha = 1
          }
          
      } else {
          UIView.animate(withDuration: 0.3, animations: {
              historyView.alpha = 0
          })
      }
  }
    
    // MARK: - User Function
    /**
     # manageFilterView
     - Author: Mephrine
     - Date: 20.07.12
     - Parameters:
     - Returns:
     - Note: 필터 뷰 숨김 처리 관리
     */
    func manageFilterView(_ isShowing: Bool = true) {
        if isShowing {
            searchTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            Async.main(after: 0.3) { [weak self] in
                guard let self = self else { return }
                self.searchTableView.addGestureRecognizer(self.touchSuperViewGesture)
                self.view.addSubview(self.filterStackView)
                self.filterStackView.snp.makeConstraints {
                    $0.top.equalTo(self.searchBar.snp.bottom).offset(self.filterButton.bounds.height)
                    $0.left.right.equalToSuperview()
                    $0.height.height.lessThanOrEqualTo(250)
                }
                self.filterStackView.alpha = 0
                self.view.layoutIfNeeded()
                
                UIView.animate(withDuration: 0.3) {
                    self.filterStackView.alpha = 1
                }
            }
            
        } else {
            searchTableView.removeGestureRecognizer(touchSuperViewGesture)
            
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.filterStackView.alpha = 0
            }) { completion in
                filterStackView.snp.removeConstraints()
                filterStackView.removeFromSuperview()
            }
        }
    }
    
    func selectActionSort(selected: SearchSort) {

    }
    
    func selectFilter(selected: SearchFilter) {
        
    }
}

// MARK: - Click
extension BaseListViewController {
    // MARK: - Action
    @objc func hideFilterView() {
        manageFilterView(false)
    }
    
    @objc func showFilterView() {
        manageFilterView(true)
    }
    
    @objc func showSortActionSheet() {
        present(sortActionSheet, animated: true, completion: nil)
    }
    
    @objc func selectFilterView(_ gesture: UITapGestureRecognizer) {
        hideFilterView()
        guard let button = gesture.view as? UIButton,
              let selectedText = button.titleLabel?.text,
              let selectedFilter = SearchFilter(rawValue: selectedText) else { return }
      
      // 필터 스택 뷰
      if let filterButton1 = filterStackView.arrangedSubviews.filter({ $0.tag == 901 }).first as? UIButton,
          let filterButton2 = filterStackView.arrangedSubviews.filter({ $0.tag == 902 }).first as? UIButton {
        filterButton.setTitle(selectedFilter.desc, for: .normal)
        switch selectedFilter {
        case .all:
            filterButton1.setTitle(SearchFilter.blog.desc, for: .normal)
            filterButton2.setTitle(SearchFilter.cafe.desc, for: .normal)
        case .blog:
            filterButton1.setTitle(SearchFilter.all.desc, for: .normal)
            filterButton2.setTitle(SearchFilter.cafe.desc, for: .normal)
        case .cafe:
            filterButton1.setTitle(SearchFilter.all.desc, for: .normal)
            filterButton2.setTitle(SearchFilter.blog.desc, for: .normal)
        }
      }
      
      selectFilter(selected: selectedFilter)
    }
}
