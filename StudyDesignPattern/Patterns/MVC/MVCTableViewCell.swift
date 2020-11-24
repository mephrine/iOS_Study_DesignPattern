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
    thumbnailView.kf.setImage(with: thumbnailURL, placeholder: UIImage(named: "placeholder"), options: [.transition(.fade(0.3))])
    
    typeBG.backgroundColor = typeBGColor
    typeLabel.text = type
    nameLabel.text = name
    titleLabel.attributedText = title
    dateTimeLabel.text = dateTime
    dimView.isHidden = !isReading
  }
}
