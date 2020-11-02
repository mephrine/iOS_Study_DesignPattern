//
//  PrimitiveSequence+SwiftyJSONMapper.swift
//  Alamofire
//
//  Created by Akshay Bharath on 11/1/17.
//

import Foundation
import Moya
import RxSwift

/**
 # PrimitiveSequence
 - Author: Mephrine
 - Date: 20.11.02
 - Note: SwiftJSONMapper -> Codable 용으로 Refactoring
 */
extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func map<T: Codable>(to type: T.Type) -> Single<T> {
        return flatMap { response -> Single<T> in
            return Single.just(try response.map(to: type))
        }
    }
    
    func map<T: Codable>(to type: [T.Type]) -> Single<[T]> {
        return flatMap { response -> Single<[T]> in
            return Single.just(try response.map(to: type))
        }
    }
}
