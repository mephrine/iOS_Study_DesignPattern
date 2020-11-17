//
//  SearchHistoryCell.swift
//  SearchApp
//
//  Created by Mephrine on 2020/07/13.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import UIKit
import Reusable
import RxDataSources

struct HistoryTableViewSection {
    var items: [Item]
}

extension HistoryTableViewSection: SectionModelType {
    public typealias Item = String
    
    init(original: HistoryTableViewSection, items: [Item]) {
        self = original
        self.items = items
    }
}

/**
# (C) SearchHistoryCell
- Author: Mephrine
- Date: 20.07.12
- Note: 검색 히스토리를 보여주는 Cell
*/
final class SearchHistoryCell: UITableViewCell, Reusable {
  fileprivate struct Font {
    static let historyLabelTitle = UIFont.systemFont(ofSize: 14)
  }
  
  fileprivate struct Color {
    static let lineBgColor = UIColor(hex: 0x666666)
  }
  
    private lazy var historyLabel = UILabel(frame: .zero).then {
        $0.backgroundColor = .clear
        $0.textColor = .black
      $0.font = Font.historyLabelTitle
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    
    private let lineView = UIView(frame: .zero).then {
      $0.backgroundColor = Color.lineBgColor
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(historyLabel)
        addSubview(lineView)
        historyLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalTo(snp.left).offset(20)
            $0.right.equalTo(snp.right).offset(-20)
        }
        lineView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     # configure
     - Author: Mephrine
     - Date: 20.07.12
     - Parameters:
         - item : 검색 히스토리
     - Returns:
     - Note: 검색 히스토리 String 적용
    */
    func configure(item: String) {
        historyLabel.text = item
    }
}

