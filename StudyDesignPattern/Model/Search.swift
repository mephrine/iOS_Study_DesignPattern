//
//  Search.swift
//  StudyDesignPattern
//
//  Created by Mephrine on 2020/10/26.
//

import Foundation


struct SearchResult: Codable {
  private let meta: Meta?
  let items: [SearchItem]?
  let isEnd: Bool
  let pageCount: Int
  let totalCount: Int
 
  enum CodingKeys: String, CodingKey {
    case meta
    case items = "documents"
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.meta = try? values.decode(Meta.self, forKey: .meta)
    self.isEnd = meta?.isEnd ?? true
    self.pageCount = meta?.pageCount ?? 0
    self.totalCount = meta?.totalCount ?? 0
    self.items = (try? values.decode([SearchItem].self, forKey: .items))
  }
  
  private struct Meta: Codable {
    let isEnd: Bool
    let pageCount: Int
    let totalCount: Int
    
    enum CodingKeys: String, CodingKey {
      case isEnd = "is_end"
      case pageCount = "pageable_count"
      case totalCount = "total_count"
    }
    
    init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      self.isEnd = try values.decode(Bool.self, forKey: .isEnd) ?? true
      self.pageCount = try values.decode(Int.self, forKey: .pageCount) ?? 0
      self.totalCount = try values.decode(Int.self, forKey: .totalCount) ?? 0
    }
  }
}

struct SearchItem: Codable {
  private var cafeName: String? = nil
  private var blogName: String? = nil
  let contents: String
  let datetime: String
  let thumbnail: String?
  let title: String
  let url: String?
  var type: String = ""
  var name: String = ""
  var isReading: Bool = false
  
  enum CodingKeys: String, CodingKey {
    case name
    case cafeName = "cafename"
    case blogName = "blogname"
    case contents
    case datetime
    case thumbnail
    case title
    case url
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.cafeName = try? values.decode(String.self, forKey: .cafeName)
    if let name = cafeName {
      self.name = name
      self.type = "cafe"
    }
    
    self.blogName = try? values.decode(String.self, forKey: .blogName)
    if let name = blogName {
      self.name = name
      self.type = "blog"
    }
    
    self.contents = try values.decode(String.self, forKey: .contents) ?? ""
    self.datetime = try values.decode(String.self, forKey: .datetime) ?? ""
    self.thumbnail = try? values.decode(String.self, forKey: .thumbnail)
    self.title = try values.decode(String.self, forKey: .title) ?? ""
    self.url = try? values.decode(String.self, forKey: .url)
  }
}

