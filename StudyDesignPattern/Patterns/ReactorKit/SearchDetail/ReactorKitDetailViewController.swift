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

final class ReactorKitDetailViewController: BaseDetailViewController, View {
    var disposeBag = DisposeBag()
    
    // MARK: - Constructor
    init(reactor: ReactorKitDetailReactor) {
        super.init()
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - UI
    override func initView() {
//      urlLabel.attributedText = NSAttributedString.init(string: )
    }

  // MARK: - Bind
  func bind(reactor: ReactorKitDetailReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
  
  private func bindAction(reactor: ReactorKitDetailReactor) {
    // Action
    Observable.just(Reactor.Action.loadView)
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
  }
  
  private func bindState(reactor: ReactorKitDetailReactor) {
    // State
    reactor.state.map{ $0.thumbnailURL }
        .filterNil()
        .subscribe(onNext: { [weak self] in
            self?.thumnailView.kf.setImage(with: $0, placeholder: UIImage(named: "placeholder"), options: [.transition(.fade(0.3))])
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
    
    override func clickToBackButton() {
        reactor?.goBack()
    }
}
