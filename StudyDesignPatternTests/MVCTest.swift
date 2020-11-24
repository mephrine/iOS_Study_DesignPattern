//
//  StudyDesignPatternTests.swift
//  StudyDesignPatternTests
//
//  Created by Mephrine on 2020/10/25.
//

import Quick
import Nimble
@testable import StudyDesignPattern

class MVCTest: QuickSpec {
    override func spec() {
      var service: NonRxAppService!
      var viewController: MVCListViewController!

      // 모든 example가 실행되기 전에 실행.
      beforeSuite {
        service = NonRxAppService(searchService: NonRxSearchServiceStub())
        viewController = MVCListViewController(service: service)
      }

      // 모든 example가 실행되고난 후에 실행.
      afterSuite {
        
      }
      
      describe("Check function part for collection") {
        context("Sorting") {
          it("Check in korean") {
            expect(viewController.sortText(str1: "배고프다", str2: "난 졸린데?")).to(equal(true))
          }
          
          it("Check in english") {
            expect(viewController.sortText(str1: "xyzabcd", str2: "aaskfnwknflkwenflkwnfle")).to(equal(true))
          }
        }
      }
  }
}

