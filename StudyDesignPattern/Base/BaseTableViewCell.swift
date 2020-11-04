//
//  BaseTableViewCell.swift
//  StudyDesignPattern
//
//  Created by Mephrine on 2020/11/01.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
  // MARK: - Const
  internal struct Font {
    static let titleLabelTitle = UIFont.systemFont(ofSize: 17)
    static let dateTimeLabelTitle = UIFont.systemFont(ofSize: 15)
    static let typeLabelTitle = UIFont.boldSystemFont(ofSize: 14)
    static let nameLabelTitle = UIFont.systemFont(ofSize: 13)
  }
  
  fileprivate struct Color {
    static let typeLabelTextColor = UIColor(hex: 0x000000)
    static let otherLabelTextColor = UIColor(hex: 0xffffff)
    static let dimBbColor = UIColor(hex: 0xccffffff)
  }
  
  fileprivate struct Metric {
    
  }
  
  // MARK: - View
  let thumbnailView = UIImageView(frame: .zero).then {
    $0.contentMode = .scaleAspectFit
    $0.image = UIImage(named: "placeholder")
  }
  
  lazy var typeBG = UIView(frame: .zero).then {
    $0.addSubview(typeLabel)
  }

  let typeLabel = UILabel(frame: .zero).then {
    $0.font = Font.typeLabelTitle
    $0.textColor = Color.typeLabelTextColor
    $0.numberOfLines = 1
    $0.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751), for: NSLayoutConstraint.Axis.horizontal)
    
    $0.snp.makeConstraints {
      $0.top.equalToSuperview().offset(2)
      $0.bottom.equalToSuperview().inset(1)
      $0.left.equalToSuperview().offset(5)
      $0.right.equalToSuperview().inset(5)
    }
  }
  let nameLabel = UILabel(frame: .zero).then {
    $0.font = Font.nameLabelTitle
    $0.textColor = Color.otherLabelTextColor
    $0.numberOfLines = 1
  }
  
  let titleLabel = UILabel(frame: .zero).then {
    $0.font = Font.titleLabelTitle
    $0.textColor = Color.otherLabelTextColor
    $0.numberOfLines = 2
  }
  
  let dateTimeLabel = UILabel(frame: .zero).then {
    $0.font = Font.dateTimeLabelTitle
    $0.textColor = Color.otherLabelTextColor
    $0.numberOfLines = 1
  }
  
  let dimView = UIView(frame: .zero).then {
    $0.backgroundColor = Color.dimBbColor
  }
  
  let containerView = UIView(frame: .zero)
  
  lazy var headerView = UIView(frame: .zero).then {
    $0.addSubview(typeBG)
    $0.addSubview(nameLabel)

    typeBG.snp.makeConstraints {
      $0.top.bottom.left.equalToSuperview()
    }
    nameLabel.snp.makeConstraints {
      $0.left.equalTo(typeBG.snp.right).inset(15)
      $0.top.bottom.right.equalToSuperview()
    }
  }
  
  // MARK: - UI
  func initView() {
    addSubview(headerView)
    addSubview(containerView)
    addSubview(thumbnailView)
    addSubview(dimView)
  }
  
  func constraints() {
    containerView.snp.makeConstraints {
      $0.left.equalToSuperview().offset(20)
      $0.top.equalTo(thumbnailView.snp.top)
      $0.bottom.equalTo(thumbnailView.snp.bottom)
      $0.right.equalTo(thumbnailView.snp.left).offset(15)
    }
    
    headerView.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(headerView.snp.bottom).offset(10)
      $0.left.right.equalToSuperview()
    }
    
    dateTimeLabel.snp.makeConstraints {
      $0.top.greaterThanOrEqualTo(titleLabel.snp.bottom).offset(10)
      $0.left.right.bottom.equalToSuperview()
    }
    
    thumbnailView.snp.makeConstraints {
      $0.right.equalToSuperview().inset(20)
      $0.top.equalToSuperview().offset(10)
      $0.bottom.equalToSuperview().inset(10)
    }
    
    dimView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  // MARK: Initializing
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      
    initView()
    constraints()
    self.selectionStyle = .none
  }
  
  required convenience init?(coder: NSCoder) {
    self.init(style: .default, reuseIdentifier: nil)
  }
  
  
  override func awakeFromNib() {
      super.awakeFromNib()
//      self.selectionStyle = .none
  }
}
