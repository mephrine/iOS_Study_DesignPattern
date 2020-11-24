//
//  UserDefaults+.swift
//  StudyDesignPattern
//
//  Created by Mephrine on 2020/11/01.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    // 검색 히스토리 내역
    var serachHistory: DefaultsKey<[String]?> { .init("serachHistory") }
}
