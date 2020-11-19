//
//  BaseDetailViewController.swift
//  StudyDesignPattern
//
//  Created by Mephrine on 2020/11/01.
//

import UIKit


//public protocol DetailNavigationAction: AnyObject {
//    func clickToBackButton()
//}

fileprivate struct Font {
  static let defaultSettingLabelTitle = UIFont.systemFont(ofSize: 17)
}

fileprivate extension UILabel {
    var defaultSetting: UILabel {
        contentMode = .scaleAspectFit
      font = Font.defaultSettingLabelTitle
        return self
    }
}

class BaseDetailViewController: BaseViewController {
  fileprivate struct Color {
    static let urlLabelTextColor = UIColor(hex: 0x0395FF)
  }
  
    // MARK: - Variable
    let thumnailView = UIImageView(frame: .zero).then {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.contentMode = .scaleAspectFit
      $0.image = UIImage(named: "placeholder")
    }
    let nameLabel = UILabel(frame: .zero).then {
      $0.translatesAutoresizingMaskIntoConstraints = false
        $0.defaultSetting
            .numberOfLines = 0
    }
    let titleLabel = UILabel(frame: .zero).then {
      $0.translatesAutoresizingMaskIntoConstraints = false
        $0.defaultSetting
            .numberOfLines = 2
    }
    let contentsLabel = UILabel(frame: .zero).then {
      $0.translatesAutoresizingMaskIntoConstraints = false
        $0.defaultSetting
            .numberOfLines = 0
    }
    let dateTimeLabel = UILabel(frame: .zero).then {
      $0.translatesAutoresizingMaskIntoConstraints = false
        $0.defaultSetting
            .numberOfLines = 1
    }
    lazy var urlLabel = UILabel(frame: .zero).then {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.defaultSetting.numberOfLines = 2
      $0.textColor = Color.urlLabelTextColor
      
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToOpenBrowser))
      $0.isUserInteractionEnabled = true
      $0.addGestureRecognizer(tapGesture)
    }
    
  lazy var contentView = UIView(frame: .zero).then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.addSubview(thumnailView)
    $0.addSubview(nameLabel)
    $0.addSubview(titleLabel)
    $0.addSubview(contentsLabel)
    $0.addSubview(dateTimeLabel)
    $0.addSubview(urlLabel)
    
    thumnailView.snp.makeConstraints {
          $0.width.equalToSuperview().multipliedBy(0.4)
          $0.centerX.equalToSuperview()
          $0.top.equalToSuperview().offset(40)
          $0.height.equalTo(thumnailView.snp.width)
      }
      
      nameLabel.snp.makeConstraints {
          $0.left.equalToSuperview().offset(20)
          $0.right.equalToSuperview().inset(20)
          $0.top.equalTo(thumnailView.snp.bottom).offset(40)
      }
      
      titleLabel.snp.makeConstraints {
          $0.left.equalTo(nameLabel.snp.left)
          $0.right.equalTo(nameLabel.snp.right)
          $0.top.equalTo(nameLabel.snp.bottom).offset(10)
      }
      
      contentsLabel.snp.makeConstraints {
          $0.left.equalTo(nameLabel.snp.left)
          $0.right.equalTo(nameLabel.snp.right)
          $0.top.equalTo(titleLabel.snp.bottom).offset(10)
      }
      
      dateTimeLabel.snp.makeConstraints {
          $0.left.equalTo(nameLabel.snp.left)
          $0.right.equalTo(nameLabel.snp.right)
          $0.top.equalTo(contentsLabel.snp.bottom).offset(10)
      }
      
      urlLabel.snp.makeConstraints {
          $0.left.equalTo(nameLabel.snp.left)
          $0.right.equalTo(nameLabel.snp.right)
          $0.top.equalTo(dateTimeLabel.snp.bottom).offset(10)
          $0.bottom.greaterThanOrEqualToSuperview().inset(10)
      }
  }
    
  lazy var scrollView = UIScrollView(frame: .zero).then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.addSubview(contentView)
    
    contentView.snp.makeConstraints {
        $0.edges.equalToSuperview()
        $0.height.equalToSuperview().priority(250)
      $0.width.equalToSuperview()
    }
  }
    
//    public private(set) weak var delegate: DetailNavigationAction?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
      super.viewDidLoad()
    }
    
    // MARK: - UI
    override func initView() {
      view.backgroundColor = .white
      
      //navi
      let button = UIButton(frame: CGRect.zero)
      button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
      button.setImage(UIImage(named: "navi_back"), for: .normal)
      button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 27)
              
      let naviItem = UIBarButtonItem.init(customView: button)
      naviItem.customView?.snp.makeConstraints{
        $0.width.height.equalTo(40)
      }
        
      navigationItem.leftBarButtonItem = naviItem
        
      // ScrollView
      view.addSubview(scrollView)
      
      
      
    }
    
  override func constraints() {
    scrollView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
      $0.left.bottom.right.equalToSuperview()
    }
  }
    
  // MARK: - Click
  @objc private func goBack() {
    clickToBackButton()
  }
  
  @objc private func goToOpenBrowser() {
    clickURL()
  }
  
  func clickToBackButton() {
        
  }
  
  func clickURL() {
    
  }
}
