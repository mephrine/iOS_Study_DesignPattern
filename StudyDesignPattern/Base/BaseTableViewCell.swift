//
//  BaseTableViewCell.swift
//  StudyDesignPattern
//
//  Created by Mephrine on 2020/11/01.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
  let thumbnailView = UIImageView(frame: .zero)
  lazy var typeBG = UIView(frame: .zero)
  let typeLabel = UILabel(frame: .zero)
  let nameLabel = UILabel(frame: .zero)
  let titleLabel = UILabel(frame: .zero)
  let dateTimeLabel = UILabel(frame: .zero)
  let dimView = UIView(frame: .zero)
  
  
  override func awakeFromNib() {
      super.awakeFromNib()
      self.selectionStyle = .none
  }

  // MARK: Initializing
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }

  required convenience init?(coder aDecoder: NSCoder) {
    self.init(style: .default, reuseIdentifier: nil)
  }
}
