//
//  BaseDetailViewController.swift
//  StudyDesignPattern
//
//  Created by Mephrine on 2020/11/01.
//

import UIKit



fileprivate extension UILabel {
    var defaultSetting: UILabel {
        self.contentMode = .scaleAspectFit
        self.font = Font(.Medium, size: 17)
        return self
    }
}

//public protocol DetailNavigationAction: AnyObject {
//    func clickToBackButton()
//}

class BaseDetailViewController: BaseViewController {
    // MARK: - Variable
    let thumnail = UIImageView(frame: .zero).then {
        $0.contentMode = .scaleAspectFit
    }
    let nameLabel = UILabel(frame: .zero).then {
        $0.defaultSetting
            .numberOfLines = 0
    }
    let titleLabel = UILabel(frame: .zero).then {
        $0.defaultSetting
            .numberOfLines = 2
    }
    let contentsLabel = UILabel(frame: .zero).then {
        $0.defaultSetting
            .numberOfLines = 0
    }
    let dateTimeLabel = UILabel(frame: .zero).then {
        $0.defaultSetting
            .numberOfLines = 1
    }
    let urlLabel = UILabel(frame: .zero).then {
        $0.defaultSetting
            .numberOfLines = 2
    }
    
    var contentView = UIView(frame: .zero)
    
    var scrollView = UIScrollView(frame: .zero)
    
//    public private(set) weak var delegate: DetailNavigationAction?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - UI
    override func initView() {
        //navi
        let button = UIButton(frame: CGRect.zero)
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        button.setImage(UIImage(named: "navi_back"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 27)
                
        let naviItem = UIBarButtonItem.init(customView: button)
        naviItem.customView?.snp.makeConstraints{
            $0.width.height.equalTo(40)
        }
        
        self.navigationItem.leftBarButtonItem = naviItem
        
        // ScrollView
        scrollView.addSubview(contentView)
        contentView.addSubview(thumnail)
        contentView.addSubview(nameLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentsLabel)
        contentView.addSubview(dateTimeLabel)
        contentView.addSubview(urlLabel)
    }
    
    override func constraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview().priority(250)
        }
        
        thumnail.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.4)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(40)
            $0.height.equalTo(thumnail.snp.width)
        }
        
        nameLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().inset(20)
            $0.top.equalTo(thumnail.snp.bottom).offset(40)
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
    
    // MARK: - Click
    @objc private func goBack() {
        clickToBackButton()
    }
    
    func clickToBackButton() {
        
    }
}
