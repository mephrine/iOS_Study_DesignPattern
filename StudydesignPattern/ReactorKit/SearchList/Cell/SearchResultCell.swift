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
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var typeBG: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var dimView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
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
        self.thumbnail.kf.setImage(with: model.thumbnailURL, placeholder: UIImage(named: "placeholder"), options: [.transition(.fade(ANIMATION_DURATION))])
        self.typeBG.backgroundColor = model.typeBGColor
        self.typeLabel.text = model.type
        self.nameLabel.text = model.name
        self.titleLabel.attributedText = model.title
        self.dateTimeLabel.text = model.dateTime
        self.dimView.isHidden = !model.isReading
    }
}

