//
//  AppService.swift
//  SearchApp
//
//  Created by Mephrine on 2020/07/12.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import Foundation

/**
 # (S) AppService
 - Author: Mephrine
 - Date: 20.07.12
 - Note: 앱에서 사용될 서비스를 관리하는 구조체
*/

struct AppService: HasSearchService {
    let searchService: SearchService
}
