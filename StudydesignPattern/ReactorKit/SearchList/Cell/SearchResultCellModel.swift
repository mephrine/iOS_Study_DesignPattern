//
//  SearchResultCellModel.swift
//  SearchApp
//
//  Created by Mephrine on 2020/07/12.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import Foundation
import RxDataSources

struct SearchTableViewSection {
    var items: [Item]
}

extension SearchTableViewSection: SectionModelType {
    public typealias Item = SearchItem
    
    init(original: SearchTableViewSection, items: [Item]) {
        self = original
        self.items = items
    }
}

/**
# (S) SearchResultCellModel
- Author: Mephrine
- Date: 20.07.12
- Note: 검색 결과 정보를 보여주는 Cell의 Model
*/
struct SearchResultCellModel {
    let model: SearchItem
    
    var thumbnailURL: URL? {
        if let thumbnail = model.thumbnail {
            return URL(string:thumbnail)
        }
        return nil
    }
    
    var typeBGColor: UIColor {
        if model.type == "cafe" {
            return .red
        } else {
            return .green
        }
    }
    
    var type: String {
        return model.type ?? ""
    }
    
    var name: String {
        return model.name ?? ""
    }
    
    var title: NSAttributedString? {
        return model.title?.htmlAttributedString(font: Utils.Font(.Regular, size: 15))
    }
    
    var dateTime: String {
        return model.datetime?.toNearDateStr() ?? ""
    }
    
    var isReading: Bool {
        return model.isReading
    }

    init(model: SearchItem) {
        self.model = model
    }
}

