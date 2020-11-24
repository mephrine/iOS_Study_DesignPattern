//
//  ReactorKitViewController.swift
//  StudyDesignPattern
//
//  Created by Mephrine on 2020/10/25.
//

import UIKit
import ReactorKit
import SnapKit
import Then
import RxDataSources
import RxKeyboard
import RxOptional
import RxAnimated

final class ReactorKitListViewController: BaseListViewController, View {
    var disposeBag = DisposeBag()
    
    
    init(reactor: ReactorKitListReactor) {
        super.init()
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK : - Variable
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
    
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
  
  override func initView() {
    searchTableView.register(cellType: SearchResultCell.self)
    super.initView()
  }
    
    //MARK: - Bind
    func bind(reactor: ReactorKitListReactor) {
      bindAction(reactor: reactor)
      bindState(reactor: reactor)
       
    }
  
  private func bindAction(reactor: ReactorKitListReactor) {
    // 검색바 포커스 - 키보드가 올라올 때 / 검색바 포커스 잃은 경우 - 키보드가 사라졌을 때, 히스토리뷰 처리
    RxKeyboard.instance.isHidden
        .distinctUntilChanged()
        .map{ Reactor.Action.focusSearchBar(isFocusing: !$0)}
        .drive(reactor.action)
        .disposed(by: disposeBag)
    
    // 히스토리뷰 항목 선택했을 경우
    historyTableView.rx.modelSelected(String.self)
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
    Observable.merge(searchBar.rx.searchButtonClicked.map{ _ in }, searchButton.rx.tap.map{ _ in })
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
    if let filterButton1 = filterStackView.arrangedSubviews.filter({ $0.tag == 901 }).first as? UIButton,
        let filterButton2 = filterStackView.arrangedSubviews.filter({ $0.tag == 902 }).first as? UIButton {
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
                case .blog:
                    filterButton1.setTitle(SearchFilter.all.desc, for: .normal)
                    filterButton2.setTitle(SearchFilter.cafe.desc, for: .normal)
                case .cafe:
                    filterButton1.setTitle(SearchFilter.all.desc, for: .normal)
                    filterButton2.setTitle(SearchFilter.blog.desc, for: .normal)
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    // 항목 선택했을 경우
    searchTableView.rx.modelSelected(SearchItem.self)
        .throttle(.milliseconds(300), latest: false, scheduler: Schedulers.main)
        .map { Reactor.Action.selectList(selected: $0) }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
    
    
    // 마지막 Section의 마지막 Row가 보여질 경우 다음 페이지 데이터 불러오기
    searchTableView.rx.willDisplayCell
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
  
  private func bindState(reactor: ReactorKitListReactor) {
    // TableView
    reactor.state
        .map{ $0.resultList }
        .observeOn(Schedulers.main)
        .bind(to: searchTableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
    
    reactor.state
        .map { $0.historyList }
        .do(onNext: { [weak self] in
            self?.manageHistoryView(!$0.isEmpty)
        })
        .observeOn(Schedulers.main)
        .bind(to: historyTableView.rx.items(dataSource: historyDataSource))
        .disposed(by: disposeBag)
    
    // 데이터가 없거나 SearchBar 검색어가 비어있는 경우
    reactor.state.map{ $0.noDataText }
        .distinctUntilChanged()
        .observeOn(Schedulers.main)
        .subscribe(onNext: { [weak self] in
            self?.noDataView.rx.animated.fade(duration: 0.3).isHidden.onNext($0.isEmpty)
            self?.noDataLabel.rx.animated.fade(duration: 0.3).text.onNext($0)
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
  }
}



