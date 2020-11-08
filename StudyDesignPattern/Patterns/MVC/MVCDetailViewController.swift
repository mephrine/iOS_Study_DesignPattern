//
//  MVCDetailViewController.swift
//  StudyDesignPattern
//
//  Created by Mephrine on 2020/11/01.
//

import UIKit
import Kingfisher

class MVCDetailViewController: BaseDetailViewController {
  fileprivate struct Font {
    static let titleLabelTitle = UIFont.systemFont(ofSize: 15)
    static let contentLabelTitle = UIFont.systemFont(ofSize: 15)
  }
  
  let model: SearchItem
  
  init(selectedModel: SearchItem) {
    model = selectedModel
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Override
  override func initView() {
    super.initView()
    
    if let urlString = model.thumbnail, let url = URL(string:urlString) {
      thumnailView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"), options: [.transition(.fade(0.3))])
    }
    
    nameLabel.text = model.name
    titleLabel.attributedText = model.title.htmlAttributedString(font: Font.titleLabelTitle)
    contentsLabel.attributedText = model.contents.htmlAttributedString(font: Font.contentLabelTitle)
    dateTimeLabel.text = model.datetime
    urlLabel.text = model.url
  }
  
  override func clickToBackButton() {
    self.navigationController?.popViewController(animated: true)
  }
}
