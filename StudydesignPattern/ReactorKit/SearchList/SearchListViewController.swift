//
//  SearchListViewController.swift
//  SearchApp
//
//  Created by Mephrine on 2020/07/12.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import ReactorKit
import Reusable
import RxAnimated
import RxDataSources
import RxKeyboard
import RxOptional
import RxSwift
import SnapKit
import Then
import UIKit

/**
 # (C) SearchListViewController
 - Author: Mephrine
 - Date: 20.07.12
 - Note: 메인화면 ViewController
 */
final class SearchListViewController: BaseViewController, View, StoryboardBased {
    //MARK : - Variable
    // Gesture
    lazy var touchSuperViewGesture = TouchDownGestureRecognizer(target: self, action: #selector(hideFilterView))
    
    // TableView DataSource
    typealias MainDataSource = RxTableViewSectionedReloadDataSource<SearchTableViewSection>
    private var dataSource: MainDataSource {
        return .init(configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            let cell: SearchResultCell = tableView.dequeueReusableCell(for: indexPath)
            let cellModel = SearchResultCellModel(model: item)
            cell.configure(model: cellModel)
            
            return cell
        })
    }
    
    typealias HistoryDataSource = RxTableViewSectionedReloadDataSource<HistoryTableViewSection>
    private var historyDataSource: HistoryDataSource {
        return .init(configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            let cell: SearchHistoryCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(item: item)
            
            return cell
        })
    }
    
    //MARK: - View
    // searchBar
    private var searchBar = UISearchBar(frame: .zero).then {
        $0.placeholder = STR_SEARCH_PLACE_HOLDER
        $0.searchBarStyle = .prominent
        $0.sizeToFit()
        $0.isTranslucent = false
        
        if #available(iOS 13.0, *) {
            $0.setShowsScope(true, animated: true)
        }
    }
    
    let searchButton = UIButton(frame: .zero).then {
        $0.backgroundColor = UIColor(hex: 0x86a4e7)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = Utils.Font(.Bold, size: 18)
        $0.setTitle(STR_SEARCH_BUTTON, for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // history
    private lazy var historyTableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(cellType: SearchHistoryCell.self)
        $0.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        $0.rowHeight = 40
        $0.separatorStyle = .none
        $0.backgroundColor = .white
        if #available(iOS 11.0, *) {
            $0.contentInsetAdjustmentBehavior = .never
        }
    }
    
    private lazy var historyView = UIView(frame: .zero).then {
        $0.backgroundColor = UIColor(hex: 0x000000, alpha: 0.7)
    }
    
    // headerView
    private var headerView = UIView(frame: .zero).then {
        $0.backgroundColor = .white
    }
    
    let filterButton = UIButton(frame: .zero).then {
        $0.backgroundColor = .white
        $0.setTitleColor(.black, for: .normal)
        $0.contentHorizontalAlignment = .left
        $0.titleLabel?.font = Utils.Font(.Bold, size: 18)
        $0.setTitle(SearchFilter.all.desc, for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    // filter view
    let filterStackView = UIStackView(frame: .zero).then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 0
        $0.backgroundColor = .white
        $0.layoutMargins = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        
        let filterButton1 = UIButton(frame: .zero).then {
            $0.backgroundColor = .white
            $0.setTitleColor(.black, for: .normal)
            $0.contentHorizontalAlignment = .left
            $0.titleLabel?.font = Utils.Font(.Bold, size: 18)
            $0.setTitle(SearchFilter.blog.desc, for: .normal)
            $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            $0.tag = 901
        }
        
        let filterButton2 = UIButton(frame: .zero).then {
            $0.backgroundColor = .white
            $0.setTitleColor(.black, for: .normal)
            $0.contentHorizontalAlignment = .left
            $0.titleLabel?.font = Utils.Font(.Bold, size: 18)
            $0.setTitle(SearchFilter.cafe.desc, for: .normal)
            $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            $0.tag = 902
        }
        
        let lineView = UIView(frame: .zero).then {
            $0.backgroundColor = UIColor(hex: 0x666666)
        }
        
        let lineView2 = UIView(frame: .zero).then {
            $0.backgroundColor = UIColor(hex: 0x666666)
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
        $0.backgroundColor = .clear
        $0.setImage(UIImage(named: "icon_search_filter"), for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    private lazy var sortActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet).then {
        $0.addAction(UIAlertAction(title: SearchSort.accuracy.rawValue, style: .default, handler: { result in
            self.reactor?.action.onNext(Reactor.Action.selectSort(selected: SearchSort.accuracy.rawValue))
        }))
        $0.addAction(UIAlertAction(title: SearchSort.recency.rawValue, style: .default, handler: { result in
            self.reactor?.action.onNext(Reactor.Action.selectSort(selected: SearchSort.recency.rawValue))
        }))
        
        $0.addAction(UIAlertAction(title: STR_CANCEL, style: .cancel, handler: nil))
    }
    
    private var headerBottomLineView = UIView(frame: .zero).then {
        $0.backgroundColor = UIColor(hex:0x666666)
    }
    
    // tableview
    private lazy var searchTableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(cellType: SearchResultCell.self)
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
    private var noDataView = UIView(frame: .zero).then {
        $0.backgroundColor = .white
    }
    
    private var noDataLabel = UILabel(frame: .zero).then {
        $0.backgroundColor = .clear
        $0.textColor = .black
        $0.text = STR_SEARCH_NO_INPUT
        $0.font = Utils.Font(.Bold, size: 24)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private lazy var loadingView =  UIActivityIndicatorView(style: .gray).then {
        $0.frame = CGRect(x: 0, y: 0, width: self.searchTableView.bounds.width, height: 44)
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Async.main(after: ANIMATION_DURATION * 2) { [weak self] in
            self?.searchBar.becomeFirstResponder()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
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
        
        self.constraints()
    }
    
    /**
     # constraints
     - Author: Mephrine
     - Date: 20.07.12
     - Parameters:
     - Returns:
     - Note: 오토레이아웃 적용
     */
    func constraints() {
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
            $0.top.left.bottom.right.equalToSuperview()
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
                    $0.height.height.lessThanOrEqualTo(250)
                }
            }
            
            self.historyView.alpha = 0
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: ANIMATION_DURATION) {
                self.historyView.alpha = 1
            }
            
        } else {
            UIView.animate(withDuration: ANIMATION_DURATION, animations: {
                self.historyView.alpha = 0
            })
        }
    }
    
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
            Async.main(after: ANIMATION_DURATION) { [weak self] in
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
                
                UIView.animate(withDuration: ANIMATION_DURATION) {
                    self.filterStackView.alpha = 1
                }
            }
            
        } else {
            self.searchTableView.removeGestureRecognizer(self.touchSuperViewGesture)
            
            UIView.animate(withDuration: ANIMATION_DURATION, animations: {
                self.filterStackView.alpha = 0
            }) { completion in
                self.filterStackView.snp.removeConstraints()
                self.filterStackView.removeFromSuperview()
            }
        }
    }
    
    //MARK: - Bind
    func bind(reactor: SearchListViewModel) {
        // action
        // 검색바 포커스 - 키보드가 올라올 때 / 검색바 포커스 잃은 경우 - 키보드가 사라졌을 때, 히스토리뷰 처리
        RxKeyboard.instance.isHidden
            .distinctUntilChanged()
            .map{ Reactor.Action.focusSearchBar(isFocusing: !$0)}
            .drive(reactor.action)
            .disposed(by: disposeBag)
        
        // 히스토리뷰 항목 선택했을 경우
        self.historyTableView.rx.modelSelected(String.self)
            .throttle(.milliseconds(300), latest: false, scheduler: Schedulers.main)
            .do(onNext:{ [weak self] in
                self?.manageHistoryView(false)
                self?.searchBar.text = $0
                self?.searchBar.resignFirstResponder()
            })
            .map(Reactor.Action.tapHistory)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // searchBar에 텍스트 변경 옵션이 일어날 경우
        Observable.merge(self.searchBar.rx.searchButtonClicked.map{ _ in }, self.searchButton.rx.tap.map{ _ in })
            .map{ self.searchBar.text }
            .map{ $0?.trimSide }
            .asDriver(onErrorJustReturn: "")
            .filterNil()
            .debounce(RxTimeInterval.milliseconds(300))
            .distinctUntilChanged()
            .do(onNext: { [weak self] _ in
                self?.manageHistoryView(false)
                self?.searchBar.resignFirstResponder()
            })
            .map{ Reactor.Action.tapSearchButton(searchText: $0) }
            .drive(reactor.action)
            .disposed(by: disposeBag)
        
        // 필터 스택 뷰
        if let filterButton1 = self.filterStackView.arrangedSubviews.filter({ $0.tag == 901 }).first as? UIButton,
            let filterButton2 = self.filterStackView.arrangedSubviews.filter({ $0.tag == 902 }).first as? UIButton {
            filterButton1.rx.tap
                .do(onNext: { [weak self] in
                    self?.hideFilterView()
                })
                .map{ [filterButton1] in filterButton1.titleLabel?.text ?? "" }
                .map{ Reactor.Action.selectFilter(selected: $0) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
            
            filterButton2.rx.tap
                .do(onNext: { [weak self] in
                    self?.hideFilterView()
                })
                .map{ [filterButton2] in filterButton2.titleLabel?.text ?? "" }
                .map{ Reactor.Action.selectFilter(selected: $0) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
            
            reactor.state
                .map{ $0.filterState }
                .distinctUntilChanged()
                .subscribe(onNext:{ [weak self, filterButton1, filterButton2] in
                    self?.filterButton.setTitle($0.desc, for: .normal)
                    switch $0 {
                    case .all:
                        filterButton1.setTitle(SearchFilter.blog.desc, for: .normal)
                        filterButton2.setTitle(SearchFilter.cafe.desc, for: .normal)
                        break
                    case .blog:
                        filterButton1.setTitle(SearchFilter.all.desc, for: .normal)
                        filterButton2.setTitle(SearchFilter.cafe.desc, for: .normal)
                        break
                    case .cafe:
                        filterButton1.setTitle(SearchFilter.all.desc, for: .normal)
                        filterButton2.setTitle(SearchFilter.blog.desc, for: .normal)
                        break
                    }
                })
                .disposed(by: disposeBag)
        }
        
        
        // 항목 선택했을 경우
        self.searchTableView.rx.modelSelected(SearchItem.self)
            .throttle(.milliseconds(300), latest: false, scheduler: Schedulers.main)
            .subscribe(onNext: { [reactor] in
                reactor.moveToDetail(selected: $0)
            })
            .disposed(by: disposeBag)
        
        //stat
        // TableView
        reactor.state
            .map{ $0.resultList }
            .observeOn(Schedulers.main)
            .bind(to: self.searchTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.historyList }
            .do(onNext: { [weak self] in
                self?.manageHistoryView(!$0.isEmpty)
            })
            .observeOn(Schedulers.main)
            .bind(to: self.historyTableView.rx.items(dataSource: historyDataSource))
            .disposed(by: disposeBag)
        
        // 데이터가 없거나 SearchBar 검색어가 비어있는 경우
        reactor.state.map{ $0.noDataText }
            .distinctUntilChanged()
            .observeOn(Schedulers.main)
            .subscribe(onNext: { [weak self] in
                self?.noDataView.rx.animated.fade(duration: ANIMATION_DURATION).isHidden.onNext($0.isEmpty)
                self?.noDataLabel.rx.animated.fade(duration: ANIMATION_DURATION).text.onNext($0)
            })
            .disposed(by: disposeBag)
        
        // 재검색 시, 스크롤 상단으로 올리기
        reactor.isSearchReload
            .filter{ $0 == true }
            .filter{ _ in !reactor.isEmptyCurrentResultList() }
            .observeOn(Schedulers.main)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.searchTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }).disposed(by: disposeBag)
        
        // 로딩바 관리
        reactor.isLoading
            .distinctUntilChanged()
            .observeOn(Schedulers.main)
            .subscribe(onNext:{ [weak self] in
                guard let self = self else { return }
                if $0 {
                    self.loadingView.isHidden = false
                    self.loadingView.startAnimating()
                    self.searchTableView.tableFooterView = self.loadingView
                } else {
                    self.loadingView.stopAnimating()
                    self.searchTableView.tableFooterView = nil
                    self.loadingView.isHidden = true
                }
            }).disposed(by: disposeBag)
        
        // e.g.
        // 마지막 Section의 마지막 Row가 보여질 경우 다음 페이지 데이터 불러오기
        self.searchTableView.rx.willDisplayCell
            .filter{ _ in reactor.chkEnablePaging() }
            .subscribe(onNext: { [weak self] cell, indexPath in
                guard let self = self else { return }
                let lastSectionIndex = self.searchTableView.numberOfSections - 1
                let lastRowIndex = self.searchTableView.numberOfRows(inSection: lastSectionIndex) - 1
                if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
                    self.reactor?.action.onNext(.loadMore)
                }
            }).disposed(by: disposeBag)
    }
    
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
}



