//
//  StudyDesignPatternTests.swift
//  StudyDesignPatternTests
//
//  Created by Mephrine on 2020/10/25.
//

//import Quick
//import Nimble
//import RxBlocking
//import RxSwift
//import RxTest
//import RxCocoa
//import RxOptional
//@testable import StudyDesignPattern

//class StudyDesignPatternTests: QuickSpec {
//    override func spec() {
//        var service: AppService!
//        var reactor: SearchListViewModel!
//        var disposeBag: DisposeBag!
//
//        // 모든 example가 실행되기 전에 실행.
//        beforeSuite {
//            service = AppService(searchService: SearchServiceStub())
//            reactor = SearchListViewModel(withService: service)
//            disposeBag = DisposeBag()
//        }
//
//        // 모든 example가 실행되고난 후에 실행.
//        afterSuite {
//
//        }
//
//        describe("ititialize") {
//            it("page count") {
//                expect(reactor.currentState.page).to(equal(1))
//            }
//        }
//
//        describe("항목 관련") {
//            var viewController: SearchListViewController!
//            var filterButton1: UIButton!
//            var filterButton2: UIButton!
//            beforeSuite {
//                viewController = SearchListViewController.instantiate(withViewModel: reactor, storyBoardName: "Main")
//                viewController.loadView()
//                viewController.initView()
//                viewController.constraints()
//                filterButton1 = viewController.filterStackView.arrangedSubviews.filter({ $0.tag == 901 }).first as! UIButton
//                filterButton2 = viewController.filterStackView.arrangedSubviews.filter({ $0.tag == 902 }).first as! UIButton
//            }
//
//            context("when a sort button tapped") {
//                it("항목 선택 시") {
//                    filterButton1.sendActions(for: .touchUpInside)
//                    expect(reactor.currentState.filterState).to(equal(.cafe))
//                }
//
//                it("항목 선택 시") {
//                    reactor.action.onNext(.selectSort(selected: SearchSort.recency.rawValue))
//                    expect(reactor.currentState.sortState).to(equal(SearchSort.accuracy))
//                }
//            }
//        }
//
//
//
//
//        describe("Request search API : cafe") {
//            context("Check API for result value") {
//                it("Check first item name is correct") {
//                    do {
//                        let searchBlog = try service.searchService.fetchSearchCafe("", .accuracy, 1).toBlocking().first()
//                        expect(searchBlog?.items?.first?.name!).to(equal("＊여성시대＊ 차분한 20대들의 알흠다운 공간"), description: "firstName is 여성시대.")
//                    } catch let error {
//                        print("error### : \(error)")
//                        fail("searchUser blocking error")
//                    }
//                }
//            }
//        }
//
//
//        describe("Request search API : blog") {
//            context("Check API for result value") {
//                it("Check first item name is correct") {
//                    do {
//                        let searchBlog = try service.searchService.fetchSearchBlog("", .accuracy, 1).toBlocking().first()
//                        expect(searchBlog?.items?.first?.name!).to(equal("핑크빛 장미"), description: "firstName is 여성시대.")
//                    } catch let error {
//                        print("error### : \(error)")
//                        fail("searchUser blocking error")
//                    }
//                }
//            }
//        }
//    }
//}

