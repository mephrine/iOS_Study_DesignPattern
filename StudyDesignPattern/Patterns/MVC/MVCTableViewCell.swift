//
//  MVCTableViewCell.swift
//  StudyDesignPattern
//
//  Created by Mephrine on 2020/11/02.
//

import UIKit
import Reusable

class MVCTableViewCell: BaseTableViewCell, Reusable {
  private var model: SearchItem?
  var thumbnailURL: URL? {
      if let thumbnail = model?.thumbnail {
          return URL(string:thumbnail)
      }
      return nil
  }
  
  var typeBGColor: UIColor {
      if model?.type == "cafe" {
          return .red
      } else {
          return .green
      }
  }
  
  var type: String {
      return model?.type ?? ""
  }
  
  var name: String {
      return model?.name ?? ""
  }
  
  var title: NSAttributedString? {
    return model?.title.htmlAttributedString(font: Font.titleLabelTitle)
  }
  
  var dateTime: String {
      return model?.datetime.toNearDateStr() ?? ""
  }
  
  var isReading: Bool {
      return model?.isReading ?? false
  }
  
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
