//
//  JSON+Ext.swift
//  StudyDesignPattern
//
//  Created by Mephrine on 2020/10/26.
//

import Foundation
import SwiftyJSON

extension JSON {
    /**
     # to<T>
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
        - type : T? (Generic)
     - Returns: Any?
     - Note: SwiftyJSON 라이브러리에서 JSON 타입을 원하는 타입으로 변경하는데 사용되는 함수
    */
    public func to<T>(type: T?) -> Any? {
        if let baseObj = type as? ALSwiftyJSONAble.Type {
            if self.type == .array {
                var arrObject: [Any] = []
                for obj in self.arrayValue {
                    let object = baseObj.init(jsonData: obj)
                    arrObject.append(object!)
                }
                return arrObject
            } else {
                let object = baseObj.init(jsonData: self)
                return object!
            }
        }
        return nil
    }
}

