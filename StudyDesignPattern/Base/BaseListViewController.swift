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





class BaseListViewController: BaseViewController, SelectSortProtocol {
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
            self.selectActionSort(selected: SearchSort.accuracy)
        }))
        $0.addAction(UIAlertAction(title: SearchSort.recency.rawValue, style: .default, handler: { result in
            self.selectActionSort(selected: SearchSort.recency)
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
        $0.backgroundColor = .clear
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
        $0.frame = CGRect(x: 0, y: 0, width: self.searchTableView.bounds.width, height: 44)
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
        // search Bar
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.searchButton)
        //navi
//        let searchButtonItem = UIBarButtonItem.init(customView: self.searchButton)
//        self.navigationItem.rightBarButtonItem = searchButtonItem
//
//        let searchBarItem = UIBarButtonItem.init(customView: self.searchBar)
//        self.navigationItem.leftBarButtonItem = searchBarItem
        
        
        // tableView
        self.view.addSubview(self.searchTableView)
        
        // tablewView HeaderView
        self.searchTableView.addSubview(self.headerView)
        self.searchTableView.tableHeaderView = self.headerView
        self.headerView.addSubview(self.filterButton)
        self.headerView.addSubview(self.sortButton)
        self.headerView.addSubview(self.headerBottomLineView)
        
        // noData View
        self.view.addSubview(self.noDataView)
        self.noDataView.addSubview(self.noDataLabel)
        
        // Gesture
        let tapSortGesture = UITapGestureRecognizer(target: self, action: #selector(showSortActionSheet))
        self.sortButton.addGestureRecognizer(tapSortGesture)
        
        // 필터뷰 버튼 클릭
        let tapFilterGesture = UITapGestureRecognizer(target: self, action: #selector(showFilterView))
        self.filterButton.addGestureRecognizer(tapFilterGesture)
      
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
        self.searchBar.snp.makeConstraints { [weak self] in
            guard let self = self else { return }
            if #available(iOS 11.0, *) {
                $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            } else {
                $0.top.equalTo(self.topLayoutGuide.snp.bottom)
            }
            $0.left.equalToSuperview()
            $0.height.equalTo(self.searchBar.bounds.height)
        }

        self.searchButton.snp.makeConstraints { [weak self] in
            guard let self = self else { return }
            $0.centerY.equalTo(self.searchBar.snp.centerY)
            $0.left.equalTo(self.searchBar.snp.right)
            $0.right.equalToSuperview().offset(-10)
        }
        
        // tableView
        self.searchTableView.snp.makeConstraints{ [weak self] in
            guard let self = self else { return }
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(self.searchBar.snp.bottom)
        }
        
        
        self.headerView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(40)
        }
        // tablewView HeaderView
        self.filterButton.snp.makeConstraints { [weak self] in
            guard let self = self else { return }
            $0.left.top.bottom.equalToSuperview()
            $0.right.equalTo(self.sortButton.snp.left).offset(-10)
        }
        self.filterButton.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 749), for: .horizontal)
        self.filterButton.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .horizontal)
        
        self.sortButton.snp.makeConstraints { [weak self] in
            guard let self = self else { return }
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
            $0.width.height.equalTo(self.headerView.snp.height)
        }
        //        self.sortButton.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751), for: .horizontal)
        //        self.sortButton.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        
        self.headerBottomLineView.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        // noData View
        self.noDataLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview().offset(-40)
        }
        
        self.noDataView.snp.makeConstraints { [weak self] in
            guard let self = self else { return }
            $0.left.equalTo(self.searchTableView.snp.left)
            $0.right.equalTo(self.searchTableView.snp.right)
            $0.bottom.equalTo(self.searchTableView.snp.bottom)
            $0.top.equalTo(self.searchTableView.snp.top)
        }
        
        // history View
        self.historyView.addSubview(self.historyTableView)
        self.historyView.snp.makeConstraints {
            $0.height.lessThanOrEqualTo(125)
        }
        self.historyTableView.snp.makeConstraints {
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
          for view in self.view.subviews {
              if view == self.historyView {
                  isExist = true
                  return
              }
          }
          if !isExist {
              self.view.addSubview(self.historyView)
              self.historyView.snp.makeConstraints { [weak self] in
                  guard let self = self else { return }
                  $0.top.equalTo(self.searchBar.snp.bottom)
                  $0.left.right.equalToSuperview()
                  $0.height.lessThanOrEqualTo(250)
              }
          }
          
          self.historyView.alpha = 0
          self.view.layoutIfNeeded()
          
          UIView.animate(withDuration: 0.3) {
              self.historyView.alpha = 1
          }
          
      } else {
          UIView.animate(withDuration: 0.3, animations: {
              self.historyView.alpha = 0
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
            self.searchTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            Async.main(after: 0.3) { [weak self] in
                guard let self = self else { return }
                self.searchTableView.addGestureRecognizer(self.touchSuperViewGesture)
                self.view.addSubview(self.filterStackView)
                self.filterStackView.snp.makeConstraints { [weak self] in
                    guard let self = self else { return }
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
            self.searchTableView.removeGestureRecognizer(self.touchSuperViewGesture)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.filterStackView.alpha = 0
            }) { completion in
                self.filterStackView.snp.removeConstraints()
                self.filterStackView.removeFromSuperview()
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
        self.manageFilterView(false)
    }
    
    @objc func showFilterView() {
        self.manageFilterView(true)
    }
    
    @objc func showSortActionSheet() {
        self.present(sortActionSheet, animated: true, completion: nil)
    }
    
    @objc func selectFilterView(_ gesture: UITapGestureRecognizer) {
        hideFilterView()
        guard let button = gesture.view as? UIButton,
              let selectedText = button.titleLabel?.text,
              let selectedFilter = SearchFilter(rawValue: selectedText) else { return }
        
        selectFilter(selected: selectedFilter)
    }
}
