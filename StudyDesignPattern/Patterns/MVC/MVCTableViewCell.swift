//
//  MVCTableViewCell.swift
//  StudyDesignPattern
//
//  Created by Mephrine on 2020/11/02.
//

import UIKit
import Reusable

class MVCTableViewCell: BaseTableViewCell, Reusable {  
  func configuration(model: SearchItem) {
    self.model = model
    self.thumbnailView.kf.setImage(with: self.thumbnailURL, placeholder: UIImage(named: "placeholder"), options: [.transition(.fade(0.3))])
    
    self.typeBG.backgroundColor = self.typeBGColor
    self.typeLabel.text = self.type
    self.nameLabel.text = self.name
    self.titleLabel.attributedText = self.title
    self.dateTimeLabel.text = self.dateTime
    self.dimView.isHidden = !self.isReading
  }
}
