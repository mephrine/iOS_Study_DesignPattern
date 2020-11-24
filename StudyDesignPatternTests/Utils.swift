//
//  Utils.swift
//  StudyDesignPattern
//
//  Created by Mephrine on 2020/10/25.
//

import Foundation


func jsonStringToData<T: Codable>(_ jsonString: String) -> T? {
    if let data = jsonString.data(using: .utf8) {
        return data.decode(T.self)
    }
    return nil
}
