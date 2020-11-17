//
//  SearchResultCell.swift
//  SearchApp
//
//  Created by Mephrine on 2020/07/12.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import Kingfisher
import Reusable
import UIKit

/**
# (C) SearchResultCell
- Author: Mephrine
- Date: 20.07.12
- Note: 검색 결과를 보여주는 Cell
*/
final class SearchResultCell: UITableViewCell, NibReusable {
  @IBOutlet weak var thumbnailView: UIImageView!
  @IBOutlet weak var typeBG: UIView!
  @IBOutlet weak var typeLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var dateTimeLabel: UILabel!
  @IBOutlet weak var dimView: UIView!
    /**
     # configure
     - Author: Mephrine
     - Date: 20.07.12
     - Parameters:
         - item : Cell Model
     - Returns:
     - Note: Cell Model 정보를 Cell에 구성
    */
    func configure(model: SearchResultCellModel) {
        thumbnailView.kf.setImage(with: model.thumbnailURL, placeholder: UIImage(named: "placeholder"), options: [.transition(.fade(0.3))])
        typeBG.backgroundColor = model.typeBGColor
        typeLabel.text = model.type
        nameLabel.text = model.name
        titleLabel.attributedText = model.title
        dateTimeLabel.text = model.dateTime
        dimView.isHidden = !model.isReading
    }
}

