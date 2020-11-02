//
//  Data+.swift
//  StudyDesignPattern
//
//  Created by Mephrine on 2020/11/02.
//

import Foundation

extension Data {
    /**
     # decode<T>
     - Author: Mephrine
     - Date: 20.06.10
     - Parameters:
     - Returns: T?
     - Note: Decodable 타입을 원하는 타입으로 변경
     */
    public func decode<T>(_ type: T.Type) -> T? where T: Decodable {
        do {
          return try JSONDecoder().decode(T.self, from: self)
        } catch let error {
          log.e(error.localizedDescription)
          return nil
        }
    }
}
