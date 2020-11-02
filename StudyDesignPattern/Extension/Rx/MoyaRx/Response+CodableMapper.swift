//
//  Observable+SwiftyJSONMapper.swift
//
//  Created by Antoine van der Lee on 26/01/16.
//  Copyright © 2016 Antoine van der Lee. All rights reserved.
//

import Foundation
import Moya

/**
 # Response
 - Author: Mephrine
 - Date: 20.11.02
 - Note: SwiftJSONMapper -> Codable 용으로 Refactoring
 */
extension Response {
    func map<T: Decodable>(to type:T.Type) throws -> T {
        guard let mappedObject =  data.decode(T.self) else {
            throw MoyaError.jsonMapping(self)
        }
        
        return mappedObject
    }

    func map<T: Decodable>(to type:[T.Type]) throws -> [T] {
      let mappedObjectsArray = data.decode([T].self)
      return mappedObjectsArray ?? []
    }
}

extension Response {
    
    @available(*, unavailable, renamed: "map(to:)")
    func mapObject<T: Decodable>(type:T.Type) throws -> T {
        return try map(to: type)
    }
    
    @available(*, unavailable, renamed: "map(to:)")
    func mapArray<T: Decodable>(type:T.Type) throws -> [T] {
        return try map(to: [type])
    }
}
