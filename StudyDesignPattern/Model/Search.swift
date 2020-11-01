//
//  Search.swift
//  StudyDesignPattern
//
//  Created by Mephrine on 2020/10/26.
//

import Foundation
import SwiftyJSON

struct SearchResult: ALSwiftyJSONAble {
    let isEnd: Bool?
    let pageCount: Int?
    let totalCount: Int?
    let items: [SearchItem]?
    
    init?(jsonData: JSON) {
        self.isEnd = jsonData["meta"]["is_end"].bool
        self.pageCount = jsonData["meta"]["pageable_count"].int
        self.totalCount = jsonData["meta"]["total_count"].int
        self.items = jsonData["documents"].to(type: SearchItem.self) as? [SearchItem]
    }
}

struct SearchItem: ALSwiftyJSONAble {
    var name: String? = ""
    var type: String? = ""
    var isReading: Bool = false
    let contents: String?
    let datetime: String?
    let thumbnail: String?
    let title: String?
    let url: String?
    
    init?(jsonData: JSON) {
        if let cafeName = jsonData["cafename"].string {
            self.name = cafeName
            self.type = "cafe"
        }
        if let blogName = jsonData["blogname"].string {
            self.name = blogName
            self.type = "blog"
        }
        
        self.contents = jsonData["contents"].string
        self.datetime = jsonData["datetime"].string
        self.thumbnail = jsonData["thumbnail"].string
        self.title = jsonData["title"].string
        self.url = jsonData["url"].string
    }
}

