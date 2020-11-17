//
//  Strings+.swift
//  StudyDesignPattern
//
//  Created by Mephrine on 2020/11/01.
//

import UIKit

extension String {
    /**
     Localizable
     */
    var localized: String {
        return NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")
    }
    
    var trimSide: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func toDate(_ format: String = "yyyy-MM-dd'T'hh:mm:ss'.000'xxx") -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(identifier: "UTC")!
        return formatter.date(from: self) ?? Date()
    }
    
    func toDateKr(format: String = "yyyy-MM-dd'T'hh:mm:ss'.000'xxx") -> String {
        return toDate().dateToString(format: "yyyy년 MM월 dd일 a HH시 mm분")
    }
    
    func toNearDateStr(format: String = "yyyy-MM-dd'T'hh:mm:ss'.000'xxx") -> String {
        return toDate().dayDifference
    }
    
    func htmlAttributedString(font: UIFont) -> NSAttributedString? {
        
        guard let data = data(using: String.Encoding.utf16, allowLossyConversion: false) else {
            return nil
        }

        guard let html = try? NSMutableAttributedString(
                                        data: data,
                                     options: [.documentType: NSAttributedString.DocumentType.html],
                                     documentAttributes: nil) else {
            return nil
        }
        
        html.addAttribute(.font, value: font, range: NSMakeRange(0, html.string.utf16.count))

        return html
    }
}
