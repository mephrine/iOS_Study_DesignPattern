//
//  VIPERViewController.swift
//  StudydesignPattern
//
//  Created by Mephrine on 2020/10/25.
//

import UIKit

final class VIPERViewController: UIViewController {
    private lazy var className : String = {
        return String(describing: type(of: self))
    }()
    
    private(set) var didSetupConstraints = false
    
    private lazy var titleLabel = UILabel(frame: .zero).then {
        $0.text = className
        $0.textColor = .black
       
    }
    
    override func loadView() {
        super.loadView()
        initView()
    }
    
    override func viewDidLoad() {
      self.view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
      if !self.didSetupConstraints {
        self.setupConstraints()
        self.didSetupConstraints = true
      }
      super.updateViewConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func initView() {
        self.view.addSubview(titleLabel)
    }
}
