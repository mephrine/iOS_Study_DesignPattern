//
//  SearchDetailViewController.swift
//  SearchApp
//
//  Created by Mephrine on 2020/07/15.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import UIKit
import ReactorKit
import Reusable
import RxSwift
import RxCocoa

final class SearchDetailViewController: BaseViewController, StoryboardView, StoryboardBased {
    // MARK: - Variable
    @IBOutlet weak var thumnail: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - UI
    override func initView() {
        //navi
        let button = UIButton(frame: CGRect.zero)
        button.addTarget(reactor, action: #selector(reactor?.goBack), for: .touchUpInside)
        button.setImage(UIImage(named: "navi_back"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 27)
                
        let naviItem = UIBarButtonItem.init(customView: button)
        naviItem.customView?.snp.makeConstraints{
            $0.width.height.equalTo(40)
        }
        
        self.navigationItem.leftBarButtonItem = naviItem
    }
    
    // MARK: - Bind
    func bind(reactor: SearchDetailViewModel) {
        // Action
        Observable.just(Reactor.Action.loadView)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map{ $0.thumbnailURL }
            .filterNil()
            .subscribe(onNext: { [weak self] in
                self?.thumnail.kf.setImage(with: $0, placeholder: UIImage(named: "placeholder"), options: [.transition(.fade(ANIMATION_DURATION))])
            }).disposed(by: disposeBag)
        
        reactor.state.map{ $0.name }
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.title }
            .bind(to: titleLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.contents }
            .bind(to: contentsLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.dateTime }
            .bind(to: dateTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.url }
            .bind(to: urlLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Action
    @IBAction func tapMoveURL(_ sender: Any) {
        reactor?.moveToWebPage()
    }
}
